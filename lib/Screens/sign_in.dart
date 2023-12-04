import 'package:ayib/API/auths_functions.dart';
import 'package:ayib/Screens/home.dart';
import 'package:ayib/Screens/sign_up.dart';
import 'package:ayib/Screens/my_notification_bar.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  static const routeName = '/signin';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isButtonClicked = false;
  bool revealPassword = false;
  String errorText = '';
  bool isLoading = false;
  late Tuple2<bool, String> result;

  Future<void> handleSignIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      Tuple2<bool, String> result = await signinFn(email, password);

      if (_formKey.currentState?.validate() ?? false) {
        if (result.item1) {
          if (context.mounted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
            myNotificationBar(context, result.item2, "success");
          }
        } else {
          if (context.mounted) {
            myNotificationBar(context, result.item2, "error");
          }
          setState(() {
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
                    handleSignIn();
                    // Rest of the code
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isLoading ? Colors.green : const Color(0xFF049DFE),
                      fixedSize: Size.fromWidth(deviceWidth)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Text(
                        'Sign In',
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
                    Navigator.of(context).pushNamed(SignUp.routeName,
                        arguments: 'Passing data from SignIn');
                  },
                  child: const Text('Don\'t have an account? Sign Up'),
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
