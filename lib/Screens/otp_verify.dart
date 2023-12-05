import 'package:ayib/API/auths_functions.dart';
import 'package:ayib/Screens/home.dart';
import 'package:ayib/Screens/my_notification_bar.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});
  static const routeName = '/otp_verify';

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late List<TextEditingController> controllers;
  int currentIndex = 0;
  bool isLoading = false;
  bool resendOtp = false;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double imageWidth = deviceWidth * 0.8;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('OTP Screen'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Ayib.jpg',
                width: imageWidth, height: 250),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => buildDigitField(controllers[index], index),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: verifyOTP,
              child: Text(resendOtp == false ? 'Verify OTP' : 'Resend OTP'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDigitField(TextEditingController controller, int index) {
    return Container(
      width: 45,
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          counterText: '',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              FocusScope.of(context).nextFocus();
            }
          } else {
            if (index > 0) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
      ),
    );
  }

  Future<void> verifyOTP() async {
    String otp = controllers.map((controller) => controller.text).join();
    // Implement your OTP verification logic here
    print('Verifying OTP: $otp');

    setState(() {
      isLoading = true;
    });

    try {
      Tuple2<int, String> result =
          await verifyEmailFn("archraphr@gmail.com", otp);
      if (context.mounted) {
        if (result.item1 == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
          myNotificationBar(context, result.item2, "success");
        } else if (result.item1 == 2) {
          setState(() {
            resendOtp = true;
          });
          myNotificationBar(context, result.item2, "error");
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
}
