import 'package:ayib/API/auths_functions.dart';
import 'package:ayib/ReduxState/actions.dart';
import 'package:ayib/ReduxState/store.dart';
import 'package:ayib/Screens/otp_verify.dart';
import 'package:ayib/Screens/reset_password.dart';
import 'package:ayib/Screens/sign_in.dart';
import 'package:ayib/Screens/my_notification_bar.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  static const routeName = '/forgot';

  @override
  State<ForgotPassword> createState() => _SignInState();
}

class _SignInState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  bool isButtonClicked = false;
  bool revealPassword = false;
  String errorText = '';
  bool isLoading = false;
  late Tuple2<int, String> result;

  Future<void> handleForgot() async {
    setState(() {
      isLoading = true;
    });

    try {
      store.dispatch(InitialiseEmail(email));
      Tuple2<int, String> result = await forgotPasswordFn(email);

      if (_formKey.currentState?.validate() ?? false) {
        if (result.item1 == 1) {
          if (context.mounted) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ResetPassword()));
            myNotificationBar(context, result.item2, "success");
          }
        } else {
          if (context.mounted) {
            if (result.item1 == 2) {
              myNotificationBar(context, result.item2, "error");
            } else if (result.item1 == 3) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const OTPScreen()));
              myNotificationBar(context, result.item2, "error");
            } else {
              myNotificationBar(context, result.item2, "error");
            }
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
    double mtop = deviceHeight * 0.1;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Sign In'),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: mtop),
                Image.asset('assets/images/Ayib.jpg',
                    width: imageWidth, height: 250),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Add more validation rules if needed
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    handleForgot();
                    // Rest of the code
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isLoading ? Colors.green : const Color(0xFF049DFE),
                    fixedSize: Size.fromWidth(deviceWidth),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Text(
                        'Submit',
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
                const SizedBox(height: 16),
                // if (errorText.isNotEmpty)
                //   Text(
                //     errorText,
                //     style: const TextStyle(color: Colors.red),
                //   ),
                // const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Go back to'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignIn.routeName,
                            arguments: 'Passing data from Forgotpassword');
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Color(0xFF049DFE),
                        ),
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


// The rest of the code remains unchanged
