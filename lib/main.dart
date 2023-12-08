// import 'dart:io';

import 'package:ayib/ReduxState/store.dart';
import 'package:ayib/Screens/app_loading.dart';
import 'package:ayib/Screens/forgot_password.dart';
import 'package:ayib/Screens/home.dart';
import 'package:ayib/Screens/otp_verify.dart';
import 'package:ayib/Screens/sign_in.dart';
import 'package:ayib/Screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
// import 'package:flutter/services.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  // ByteData data =
  //     await PlatformAssetBundle().load('assets/lets-encrypt-r3.pem');
  // SecurityContext.defaultContext
  //     .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(
    StoreProvider(
      store: store,
      child: const MyApp(),
    ),
  );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Change this to the desired color
      statusBarIconBrightness:
          Brightness.dark, // Change the icon color (dark or light)
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
      routes: {
        SignIn.routeName: (ctx) => const SignIn(),
        SignUp.routeName: (ctx) => const SignUp(),
        OTPScreen.routeName: (ctx) => const OTPScreen(),
        Home.routeName: (ctx) => const Home(),
        ForgotPassword.routeName: (ctx) => const ForgotPassword(),
      },
    );
  }
}
