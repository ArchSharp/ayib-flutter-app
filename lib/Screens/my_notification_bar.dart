import 'package:flutter/material.dart';

void myNotificationBar(BuildContext context, String message, String errorType) {
  final snackBar = SnackBar(
    content: SizedBox(
      width: 700,
      height: 20,
      child: Text(message),
    ),
    duration: const Duration(seconds: 5),
    dismissDirection: DismissDirection.up,
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    backgroundColor:
        errorType == "success" ? Colors.green.shade400 : Colors.red,
    closeIconColor: Colors.teal,
    showCloseIcon: true,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
