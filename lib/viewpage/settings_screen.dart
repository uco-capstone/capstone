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
  bool _preloadedTasksEnabled = false;
  bool _notificationsEnabled = true;
  late _Controller con;
  late HomeScreenModel screenModel;
  // var formKey = GlobalKey<FormState>();
  String title = "Settings";
  // final TextEditingController ageController = TextEditingController();
  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    con.findKirbyUser();
    screenModel = HomeScreenModel(user: Auth.user!);
  }

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
              value: _preloadedTasksEnabled,
              onChanged: (value) {
                setState(() {
                  con.setPreloadedTasksEnabled(value);
                });
                // con.setPreloadedTasksEnabled(value);
                // print("value preload: " + value.toString());
              },
            ),
            SwitchListTile(
              title: const Text('Notifications'),
              value: _notificationsEnabled,
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
  KirbyUser tempKirbyUser = KirbyUser(
      userId: Auth.getUser().uid,
      firstName: Auth.getUser().displayName == null
          ? ""
          : Auth.getUser().displayName!);

  Future<void> findKirbyUser() async {
    KirbyUser pulledUser =
        await FirestoreController.getKirbyUser(userId: Auth.getUser().uid);
    tempKirbyUser = pulledUser;
    state._preloadedTasksEnabled =
        state.con.tempKirbyUser.preloadedTasks ?? true;
    state._notificationsEnabled = state.con.tempKirbyUser.notifications ?? true;
  }

  Future<void> setPreloadedTasksEnabled(value) async {
    state._preloadedTasksEnabled = value;
    Map<String, dynamic> update = {};
    update[DocKeyUser.preloadedTasks.name] = value;
    await FirestoreController.updateKirbyUser(
        userId: tempKirbyUser.userId!, update: update);
  }

  Future<void> setNotificationsEnabled(value) async {
    state._notificationsEnabled = value;
    Map<String, dynamic> update = {};
    update[DocKeyUser.notifications.name] = value;
    await FirestoreController.updateKirbyUser(
        userId: tempKirbyUser.userId!, update: update);
  }
}