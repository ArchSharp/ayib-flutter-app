import 'package:ayib/Screens/home.dart';
import 'package:flutter/material.dart';

class FundWallet extends StatefulWidget {
  const FundWallet({super.key});
  static const routeName = '/fundWallet';

  @override
  State<FundWallet> createState() => _FundWalletState();
}

class _FundWalletState extends State<FundWallet> {
  double amount = 0;
  bool isLoading = false;

  Future<void> fundwalletFn() async {}

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double imageWidth = deviceWidth * 0.8;

    return Scaffold(
      body: Center(
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
                      amount = value as double;
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
                      // Rest of the code
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
    );
  }
}
