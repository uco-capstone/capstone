import 'package:capstone/model/kirby_user_model.dart';
import 'package:capstone/viewpage/health_info_screen.dart';
import 'package:capstone/viewpage/settings_screen.dart';
import 'package:capstone/viewpage/start_dispatcher.dart';
import 'package:capstone/viewpage/todo_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:capstone/viewpage/create_account_screen.dart';
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
        SettingsScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            // TODO: return error screen instead
            var kirbyUser = args as KirbyUser;
            return SettingsScreen(kirbyUser: kirbyUser);
          } else {
            var kirbyUser = args as KirbyUser;
            return SettingsScreen(kirbyUser: kirbyUser);
          }
        },
      },
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
    );
  }
}
