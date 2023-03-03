import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  int? seconds,
}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: seconds ?? 3), //3-sec default
    action: SnackBarAction(label: 'OK', onPressed: () {}),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget kirbabButton({
  required BuildContext context,
  required fn,
}) {
  return GestureDetector(
      onTap: fn,
      child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/kirbab-icon.png"),
                fit: BoxFit.fitHeight),
          ))
      );
}
