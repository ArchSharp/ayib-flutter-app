import 'package:ayib/API/auths_functions.dart';
import 'package:ayib/Screens/otp_verify.dart';
import 'package:ayib/Screens/sign_in.dart';
import 'package:ayib/Screens/my_notification_bar.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static const routeName = '/signup';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String phoneNumber = "";

  bool revealPassword = false;
  bool isButtonClicked = false;
  String errorText = '';
  bool isLoading = false;
  late Tuple2<bool, String> result;

  Future<void> handleSignUp() async {
    setState(() {
      isLoading = true;
    });

    try {
      Tuple2<bool, String> result =
          await signupFn(email, phoneNumber, password);
      if (_formKey.currentState?.validate() ?? false) {
        if (result.item1 == true) {
          if (context.mounted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => OTPScreen()));
            myNotificationBar(context, result.item2, "success");
          }
          setState(() {
            isButtonClicked = true;
            errorText = '';
          });

          // You might want to navigate to another screen or perform user registration
        } else {
          // Failed sign-up
          if (context.mounted) {
            myNotificationBar(context, result.item2, "error");
          }
          setState(() {
            isButtonClicked = true;
            errorText = result.item2;
          });
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
    double mtop = deviceHeight * 0.07;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Sign Up'),
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
                const SizedBox(height: 8),
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
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // You can add additional phone number validation rules if needed
                    return null;
                  },
                  keyboardType: TextInputType
                      .phone, // Set the keyboard type to handle phone numbers
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons
                        .phone), // Add an icon to the left of the input field
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    // Add more validation rules if needed
                    return null;
                  },
                  obscureText: !revealPassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Handle sign-up logic
                    handleSignUp();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonClicked
                          ? Colors.blue
                          : const Color(0xFF049DFE),
                      fixedSize: Size.fromWidth(deviceWidth)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Text(
                        'Sign Up',
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
                TextButton(
                  onPressed: () {
                    // Navigate back to the SignInScreen
                    Navigator.of(context).pushNamed(SignIn.routeName,
                        arguments: 'Passing data from SignUp');
                  },
                  child: const Text('Already have an account? Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
