import 'package:capstone/view/health_info_screen.dart';
import 'package:capstone/view/start_dispatcher.dart';
import 'package:capstone/view/todo_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:capstone/view/create_account_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CapstoneApp());
}

class CapstoneApp extends StatelessWidget {
  const CapstoneApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //return const MaterialApp(
    return MaterialApp(
      title: 'Pet Planner',
      initialRoute: StartDispatcher.routeName,
      routes: {
        ToDoScreen.routeName: (context) => const ToDoScreen(),
        StartDispatcher.routeName: (context) => const StartDispatcher(),
        CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),
        HealthInfoScreen.routeName: (context) => const HealthInfoScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
    );
  }
}


