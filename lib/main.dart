import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:capstone/viewpage/achievement_screen.dart';
import 'package:capstone/viewpage/health_info_screen.dart';
import 'package:capstone/viewpage/history_screen.dart';
import 'package:capstone/viewpage/settings_screen.dart';
import 'package:capstone/viewpage/start_dispatcher.dart';
import 'package:capstone/viewpage/shop_screen.dart';
import 'package:capstone/viewpage/todo_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:capstone/viewpage/create_account_screen.dart';
import 'firebase_options.dart';
import 'viewpage/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        defaultColor: Colors.teal,
        channelDescription: 'Scheduled Notifications',
      ),
    ],
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
        HomeScreen.routeName: (context) => const HomeScreen(),
        ToDoScreen.routeName: (context) => const ToDoScreen(),
        ShopScreen.routeName: (context) => const ShopScreen(),
        AchievementScreen.routeName: (context) => const AchievementScreen(),
        StartDispatcher.routeName: (context) => const StartDispatcher(),
        CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),
        HealthInfoScreen.routeName: (context) => const HealthInfoScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        HistoryScreen.routeName: (context) => const HistoryScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
    );
  }
}
