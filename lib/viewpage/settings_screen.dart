import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/model/kirby_user_model.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../model/home_screen_model.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/settings";

  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScreen> {
  bool? preloadedtasksEnabled;
  bool? notificationsEnabled;
  late KirbyUser kirbyUser;
  late _Controller con;
  late HomeScreenModel screenModel;
  String title = "Settings";

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    con.setKirbyUser();
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
              value: con.state.kirbyUser.preloadedTasks!,
              onChanged: (value) {
                setState(() {
                  con.setPreloadedTasksEnabled(value);
                });
              },
            ),
            SwitchListTile(
              title: const Text('Notifications'),
              value: con.state.kirbyUser.notifications!,
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
  // late Future<KirbyUser> kirbyUser;
  _Controller(this.state) {
    setKirbyUser();
    initPreloadedTasksEnabled();
  }

  Future<void> setKirbyUser() async {
    KirbyUser pulledKirbyUser =
        await FirestoreController.getKirbyUser(userId: Auth.getUser().uid);
    state.kirbyUser = pulledKirbyUser;
    state.setState(() {});
  }

  Future<KirbyUser> getKirbyUser() async {
    KirbyUser pulledKirbyUser =
        await FirestoreController.getKirbyUser(userId: Auth.getUser().uid);
    return pulledKirbyUser;
  }

  Future<void> setPreloadedTasksEnabled(value) async {
    state.preloadedtasksEnabled = value;
    Map<String, dynamic> update = {};
    update[DocKeyUser.preloadedTasks.name] = value;
    await FirestoreController.updateKirbyUser(
        userId: state.kirbyUser.userId!, update: update);
  }

  Future<void> setNotificationsEnabled(value) async {
    state.notificationsEnabled = value;
    Map<String, dynamic> update = {};
    update[DocKeyUser.notifications.name] = value;
    await FirestoreController.updateKirbyUser(
        userId: state.kirbyUser.userId!, update: update);
  }

  Future<bool> getPreloadedTasksEnabled() async {
    KirbyUser pulledUser =
        await FirestoreController.getKirbyUser(userId: Auth.getUser().uid);
    state.kirbyUser = pulledUser;
    return state.kirbyUser.notifications ?? true;
  }

  bool getPreloadedTasksEnabled2() {
    return state.kirbyUser.preloadedTasks!;
  }

  Future<void> initPreloadedTasksEnabled() async {
    KirbyUser pulledUser =
        await FirestoreController.getKirbyUser(userId: Auth.getUser().uid);
    state.kirbyUser = pulledUser;
    state.kirbyUser.preloadedTasks ?? true;
    state.preloadedtasksEnabled = state.kirbyUser.preloadedTasks;
    state.setState(() {});
  }
}
