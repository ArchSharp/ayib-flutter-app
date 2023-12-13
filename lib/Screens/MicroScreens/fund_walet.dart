import 'package:ayib/API/flutterwave.dart';
import 'package:ayib/Model/payment_link.dart';
import 'package:ayib/ReduxState/store.dart';
import 'package:ayib/Screens/MicroScreens/Webview.dart';
// import 'package:ayib/Screens/MicroScreens/webview2.dart';
// import 'package:ayib/Screens/MicroScreens/webview2.txt';
import 'package:ayib/Screens/my_notification_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:tuple/tuple.dart';

class FundWallet extends StatefulWidget {
  const FundWallet({super.key});
  static const routeName = '/fundWallet';

  @override
  State<FundWallet> createState() => _FundWalletState();
}

class _FundWalletState extends State<FundWallet> {
  double amount = 0;
  bool isLoading = false;
  String paymentUrl = "";

  Future<void> fundwalletFn() async {
    // Navigator.of(context).pushNamed(WebView2.routeName, arguments: "");
    // Create an instance of ICustomer
    var user = store.state.user;
    ICustomer customer = ICustomer(
      email: user["email"],
      phoneNumber: user["phone_number"],
      name: user["lastname"] + " " + user["firstname"],
    );

    // Create an instance of IMeta
    IMeta meta = IMeta(
      consumerId: 123,
      consumerMac: 'mac_address',
    );

    // Create an instance of ICustomizations
    ICustomizations customization = ICustomizations(
      title: "ArchIntel Ltd",
      logo:
          'https://archdemy.netlify.app/static/media/archintel-nobg.1c7feb8033d0420b2461.png',
      description: 'We deliver great development',
    );

    // Create an instance of PaymentLinkPayload
    PaymentLinkPayload paymentPayload = PaymentLinkPayload(
      customer: customer,
      txRef: 'transaction_reference',
      amount: amount.toString(),
      currency: 'NGN',
      redirectUrl: 'https://example.com/redirect',
      meta: meta,
      customization: customization,
    );

    try {
      Tuple2<int, String> result =
          await createPaymentLink(paymentPayload as Flutterwave);
      if (amount > 0) {
        if (context.mounted) {
          if (result.item1 == 1) {
            Navigator.of(context)
                .pushNamed(LoadWebView.routeName, arguments: result.item2);
            // myNotificationBar(context, result.item2, "success");
          } else {
            // Failed payment link
            myNotificationBar(context, result.item2, "error");
          }
        }
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double imageWidth = deviceWidth * 0.8;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: (deviceHeight * 0.1)),
                Image.asset('assets/images/Ayib.jpg',
                    width: imageWidth, height: 250),
                SizedBox(height: (deviceHeight * 0.05)),
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        amount = double.tryParse(value)!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Amount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: (deviceHeight * 0.05)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isLoading ? Colors.green : const Color(0xFF049DFE),
                        fixedSize: Size.fromWidth(deviceWidth / 3),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 25),
                    ElevatedButton(
                      onPressed: () {
                        fundwalletFn();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isLoading ? Colors.green : const Color(0xFF049DFE),
                        fixedSize: Size.fromWidth(deviceWidth / 3),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Text(
                            'Fund',
                            style: TextStyle(color: Colors.white),
                          ),
                          if (isLoading)
                            const Positioned.fill(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
