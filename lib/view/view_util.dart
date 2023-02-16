import 'package:flutter/material.dart';

void createSnackBar({
  required BuildContext context,
  required String message,
  int? seconds,
}) {
  final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: seconds ?? 3),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
      ));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}