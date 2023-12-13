import 'package:ayib/API/auths_functions.dart';
import 'package:ayib/API/flutterwave.dart';
import 'package:ayib/ReduxState/store.dart';
import 'package:ayib/Screens/bottom_navbar.dart';
import 'package:ayib/Screens/my_notification_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:tuple/tuple.dart';

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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double imageWidth = deviceWidth * 0.8;

    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: (deviceHeight * 0.1)),
              Image.asset('assets/images/Ayib.jpg',
                  width: imageWidth, height: 250),
              SizedBox(height: (deviceHeight * 0.05)),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF049DFE),
                    fixedSize: Size.fromWidth(deviceWidth / 3),
                  ),
                  child: const Text(
                    "Fund wallet",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  _onPressed() {
    final currentState = formKey.currentState;
    if (currentState != null && currentState.validate()) {
      _handlePaymentInitialization();
    }
  }

  _handlePaymentInitialization() async {
    try {
      setState(() {
        isLoading = false;
      });

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
        txRef: 'notyet',
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

      Tuple2<int, String> result = await createPaymentLink(flutterwave);
      if (context.mounted) {
        if (result.item1 == 1) {
          flutterwave.txRef = result.item2;
          final ChargeResponse response = await flutterwave.charge();
          // showLoading(response.toString());
          print("response: ${response.toJson()}");
          flutterwave.currency = response.status!;
          flutterwave.txRef = response.txRef!;

          Tuple2<int, String> updateFund = await createPaymentLink(flutterwave);
          if (context.mounted) {
            if (updateFund.item1 == 1) {
              String respStatus =
                  response.success == true ? "success" : "error";
              String msg = response.success == true
                  ? "Funding succeeded"
                  : "Funding failed";
              if (response.success == true) {
                await fetchUserWalletFn(user["email"]);
              }
              myNotificationBar(context, msg, respStatus);
            } else {
              myNotificationBar(context, result.item2, "error");
            }
            Navigator.of(context).pop(WebView2.routeName);
          }
        } else {
          myNotificationBar(context, result.item2, "error");
        }
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
