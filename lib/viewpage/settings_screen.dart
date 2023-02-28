import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/model/kirby_user_model.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../model/home_screen_model.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/settings";
  final KirbyUser kirbyUser;

  const SettingsScreen({super.key, required this.kirbyUser});

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScreen> {
  late _Controller con;
  late HomeScreenModel screenModel;
  String title = "Settings";

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = HomeScreenModel(user: Auth.user!);
  }

  void render(fn) => setState(fn);

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Preloaded Tasks'),
              value: widget.kirbyUser.preloadedTasks!,
              onChanged: (value) {
                setState(() {
                  con.setPreloadedTasksEnabled(value);
                });
              },
            ),
            SwitchListTile(
              title: const Text('Notifications'),
              value: widget.kirbyUser.notifications!,
              onChanged: (value) {
                setState(() {
                  con.setNotificationsEnabled(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _SettingsState state;
  _Controller(this.state);

  Future<void> setPreloadedTasksEnabled(value) async {
    state.widget.kirbyUser.preloadedTasks = value;
    Map<String, dynamic> update = {};
    update[DocKeyUser.preloadedTasks.name] = value;
    await FirestoreController.updateKirbyUser(
        userId: state.widget.kirbyUser.userId!, update: update);
  }

  Future<void> setNotificationsEnabled(value) async {
    state.widget.kirbyUser.notifications = value;
    Map<String, dynamic> update = {};
    update[DocKeyUser.notifications.name] = value;
    await FirestoreController.updateKirbyUser(
        userId: state.widget.kirbyUser.userId!, update: update);
  }
}
