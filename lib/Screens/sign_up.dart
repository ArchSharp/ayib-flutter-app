import 'package:ayib/API/auths_functions.dart';
import 'package:ayib/ReduxState/actions.dart';
import 'package:ayib/ReduxState/store.dart';
import 'package:ayib/Screens/otp_verify.dart';
import 'package:ayib/Screens/sign_in.dart';
import 'package:ayib/Screens/my_notification_bar.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static const routeName = '/signup';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  String email = '';
  String firstname = '';
  String lastname = '';
  String mname = '';
  String password = '';
  DateTime? dateofbirth = null; //DateTime(2023, 01, 27);
  String phoneNumber = "";

  bool revealPassword = false;
  bool isButtonClicked = false;
  String errorText = '';
  bool isLoading = false;
  late Tuple2<int, String> result;

  Future<void> handleSignUp() async {
    setState(() {
      isLoading = true;
    });

    try {
      store.dispatch(InitialiseEmail(email));
      Tuple2<int, String> result = await signupFn(email, phoneNumber, password,
          firstname, lastname, mname, dateofbirth);
      if (_formKey.currentState?.validate() ?? false) {
        if (result.item1 == 1) {
          if (context.mounted) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const OTPScreen()));
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
  void initState() {
    super.initState();
    // Initialize the text controller with the initial date
    dateController.text =
        dateofbirth?.toString().replaceAll(RegExp(r' 00:00:00.000'), '') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double imageWidth = deviceWidth * 0.8;
    double mtop = deviceHeight * 0.03;

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
                const SizedBox(height: 2),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      lastname = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    // Add more validation rules if needed
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Last name'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      firstname = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    // Add more validation rules if needed
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'First name'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      mname = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    // Add more validation rules if needed
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Middle name'),
                ),
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
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: dateController,
                  keyboardType: TextInputType.none,
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                      initialDate: dateofbirth ?? DateTime.now(),
                    );

                    if (newDate != null) {
                      setState(() {
                        dateofbirth = newDate;
                      });

                      // Manually update the text field value
                      dateController.text = newDate
                          .toString()
                          .replaceAll(RegExp(r' 00:00:00.000'), '');
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your date of birth';
                    }
                    // You can add more specific validation rules for date of birth here
                    // For example, you might want to check if it's a valid date format.
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    hintText: 'YYYY-MM-DD',
                    // border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 8),
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
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle sign-up logic
                    handleSignUp();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isButtonClicked ? Colors.blue : const Color(0xFF049DFE),
                    fixedSize: Size.fromWidth(deviceWidth),
                  ),
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
                const SizedBox(height: 8),
                // if (errorText.isNotEmpty)
                //   Text(
                //     errorText,
                //     style: const TextStyle(color: Colors.red),
                //   ),
                // const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignIn.routeName,
                            arguments: 'Passing data from SignIn');
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
