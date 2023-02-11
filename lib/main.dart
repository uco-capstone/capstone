import 'package:capstone/view/start_dispatcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CapstoneApp());
=======
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const MyApp());
>>>>>>> bdc1f11 (add controller dir)
}

class CapstoneApp extends StatelessWidget {
  const CapstoneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Planner',
      initialRoute: StartDispatcher.routeName,
      routes: {
        StartDispatcher.routeName: (context) => const StartDispatcher(),
      },
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
    );
  }
}
