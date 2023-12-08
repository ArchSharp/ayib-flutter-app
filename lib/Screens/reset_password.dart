import 'package:ayib/API/auths_functions.dart';
import 'package:ayib/Screens/forgot_password.dart';
import 'package:ayib/Screens/otp_verify.dart';
import 'package:ayib/Screens/my_notification_bar.dart';
import 'package:ayib/Screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});
  static const routeName = '/signin';

  @override
  State<ResetPassword> createState() => _SignInState();
}

class _SignInState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String otp = '';
  String newPassword = '';
  bool isButtonClicked = false;
  bool revealPassword = false;
  String errorText = '';
  bool isLoading = false;
  late Tuple2<int, String> result;

  Future<void> handleSignIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      Tuple2<int, String> result = await resetPasswordFn(otp, newPassword);

      if (_formKey.currentState?.validate() ?? false) {
        if (context.mounted) {
          if (result.item1 == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignIn()));
            myNotificationBar(context, result.item2, "success");
          } else {
            if (result.item1 == 3) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const OTPScreen()));
              myNotificationBar(context, result.item2, "error");
            } else if (result.item1 == 5) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPassword()));
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
                      otp = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your otp';
                    }
                    // Add more validation rules if needed
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'OTP'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      newPassword = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    // Add more validation rules if needed
                    return null;
                  },
                  obscureText: !revealPassword,
                  decoration: InputDecoration(
                    labelText: 'New password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          revealPassword = !revealPassword;
                        });
                      },
                      child: Icon(
                        revealPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {
                    handleSignIn();
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
                        'Reset password',
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
                // if (errorText.isNotEmpty)
                //   Text(
                //     errorText,
                //     style: const TextStyle(color: Colors.red),
                //   ),
                // const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// The rest of the code remains unchanged
