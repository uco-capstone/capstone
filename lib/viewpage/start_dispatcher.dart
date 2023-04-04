import 'package:capstone/viewpage/home_screen.dart';
import 'package:capstone/viewpage/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';

class StartDispatcher extends StatelessWidget {
  static const routeName = "/startDispatcher";

  const StartDispatcher({Key? key}) : super(key: key);
  @override

  /*  Eli 
      - the function takes in a stream that waits for changes in auth status
      - when it is changed, if the user is null then it redirects to the login
        screen; otherwise, it redirects to the home screen
  */
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Auth.user = snapshot.data;
        return Auth.user == null ? const LoginScreen() : const HomeScreen();
      },
    );
  }
}
