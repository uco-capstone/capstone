import 'package:flutter/material.dart';
import 'package:capstone/view/todo_screen.dart';

import 'model/constant.dart';

void main() {
  runApp(const PetPlanner());
}

class PetPlanner extends StatelessWidget {
  const PetPlanner({Key? key}) : super(key: key); //constructor

  @override
  Widget build(BuildContext context) {
    //return const MaterialApp(
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      // debugShowCheckedModeBanner: Constant.dev,
      // theme: ThemeData(
      //   brightness: Brightness.dark,
      //   fontFamily: 'LobsterTwo',
      //   textTheme: const TextTheme(
      //     headline1: TextStyle(
      //       fontSize: 64.0,
      //       color: Colors.red,
      //     ),
      //     button: TextStyle(
      //       fontSize: 32.0,
      //     ),
      //   ),
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       primary: Colors.teal,
      //       elevation: 12.0,
      //       shadowColor: Colors.yellowAccent,
      //       textStyle: const TextStyle(
      //         fontSize: 28.0,
      //       ),
      //     ),
      //   ),
      //   outlinedButtonTheme: OutlinedButtonThemeData(
      //     style: OutlinedButton.styleFrom(
      //       primary: Colors.white,
      //       backgroundColor: Colors.blueAccent,
      //       textStyle: const TextStyle(fontSize: 20.0),
      //     ),
      //   ),
      //   textButtonTheme: TextButtonThemeData(
      //     style: TextButton.styleFrom(
      //       primary: Colors.yellowAccent,
      //       backgroundColor: Colors.grey,
      //       textStyle: const TextStyle(
      //         fontSize: 18.0,
      //       ),
      //     ),
      //   ),
      // ),
      initialRoute: ToDoScreen.routeName,
      //home: Text('Hello World'),
      routes: {
        //StartScreen.routeName: f1,
        ToDoScreen.routeName: (BuildContext context) => const ToDoScreen(),
      },
    );
  }
}

Widget f1(BuildContext context) {
  return const ToDoScreen();
}
