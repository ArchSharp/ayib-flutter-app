import 'package:ayib/ReduxState/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterwave_standard/flutterwave.dart';

class WebView2 extends StatefulWidget {
  const WebView2({super.key});
  static const routeName = '/webview2';

  @override
  State<WebView2> createState() => _WebView2State();
}

class _WebView2State extends State<WebView2> {
  String? apiKey = dotenv.env['PUB_KEY'];
  String? baseUrl = dotenv.env['ENC_KEY'];
  var user = store.state.user;
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: amountController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(hintText: "Amount"),
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : "Amount is required",
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: ElevatedButton(
                  onPressed: _onPressed,
                  child: const Text(
                    "Make Payment",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onPressed() {
    final currentState = formKey.currentState;
    if (currentState != null && currentState.validate()) {
      _handlePaymentInitialization();
    }
  }

  _handlePaymentInitialization() async {
    final Customer customer = Customer(
      email: user["email"],
      name: user["lastname"] + " " + user["firstname"],
      phoneNumber: user["phone_number"],
    );

    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: apiKey!,
      currency: "NGN",
      redirectUrl: 'https://facebook.com',
      txRef: "uytgu764edf",
      amount: amountController.text.toString().trim(),
      customer: customer,
      paymentOptions: "card, payattitude, barter, bank transfer, ussd",
      customization: Customization(
        title: "ArchIntel Ltd",
        logo:
            'https://archdemy.netlify.app/static/media/archintel-nobg.1c7feb8033d0420b2461.png',
        description: 'We deliver great development',
      ),
      isTestMode: true,
    );
    final ChargeResponse response = await flutterwave.charge();
    showLoading(response.toString());
    print("${response.toJson()}");
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 100,
            child: Text(message),
          ),
        );
      },
    );
  }
}
