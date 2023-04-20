import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  int? seconds,
}) {
  final snackBar = SnackBar(
    content: Column(
      children: [
        SizedBox(
          height: 40,
          child: Image.asset('images/bongo-kirby.png')
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.indigo[300],
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(message)
          )
        ),
      ],
    ),
    duration: Duration(seconds: seconds ?? 3), //3-sec default
    backgroundColor: Colors.transparent,
    elevation: 0,
    dismissDirection: DismissDirection.down,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showDialogBox({
  required BuildContext context,
  required String title,
  required String content,
  required String buttonName,
  required Function fn,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          MaterialButton(
            child: Text(buttonName),
            onPressed: () {
              fn();
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
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
            image: AssetImage("images/kirbab-icon.png"), fit: BoxFit.fitHeight),
      ),
    ),
  );
}
