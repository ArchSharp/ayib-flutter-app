import 'package:flutter/material.dart';

AlertDialog myAlertDialog(BuildContext context, String title, String msg) {
  return AlertDialog(
    title: Text(title),
    content: Text(msg),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('OK'),
      ),
    ],
  );
}
