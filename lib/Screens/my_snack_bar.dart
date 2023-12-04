import 'package:flutter/material.dart';

void mySnackBar(BuildContext context, String message, Color color) {
  double deviceWidth = MediaQuery.of(context).size.width;
  double width = deviceWidth * 0.9;
  final snackBar = SnackBar(
    content: SizedBox(
      width: width,
      child: Text(
        message,
        style: TextStyle(color: color),
      ),
    ),
    duration: const Duration(seconds: 2),
    elevation: 10,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
