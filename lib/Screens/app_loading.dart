import 'package:ayib/Screens/sign_in.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // You can perform any initialization tasks here

    // Example: Delay for 3 seconds and then navigate to the next screen
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double imageWidth = deviceWidth * 0.8;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Ayib.jpg',
                width: imageWidth, height: 250),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
