import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/model/constants.dart';
import 'package:capstone/model/kirby_user_model.dart';
import 'package:capstone/model/settings_screen_model.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/settings";
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScreen> {
  late _Controller con;
  late SettingsScreenModel screenModel;
  String title = "Settings";

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = SettingsScreenModel(user: Auth.user!);
    con.getKirbyUser();
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
      appBar: AppBar(title: const Text("Settings")),
      body: screenModel.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : settingsScreenBody(),
    );
  }

  Widget settingsScreenBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          SwitchListTile(
            title: const Text('Preloaded Tasks'),
            value: screenModel.kirbyUser!.preloadedTasks!,
            onChanged: (value) {
              setState(() {
                con.setPreloadedTasksEnabled(value);
              });
            },
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: screenModel.kirbyUser!.notifications!,
            onChanged: (value) {
              setState(() {
                con.setNotificationsEnabled(value);
              });
            },
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _SettingsState state;
  _Controller(this.state);

  Future<void> getKirbyUser() async {
    try {
      state.screenModel.loading = true;
      state.screenModel.kirbyUser =
          await FirestoreController.getKirbyUser(userId: Auth.getUser().uid);
      state.render(() {});
    } catch (e) {
      // ignore: avoid_print
      if (Constants.devMode) print(" ==== loading error $e");
      state.render(() => state.screenModel.loadingErrorMessage = "$e");
    }
    state.screenModel.loading = false;
  }

  Future<void> setPreloadedTasksEnabled(value) async {
    var kUser = state.screenModel.kirbyUser;
    kUser!.preloadedTasks = value;
    Map<String, dynamic> update = {};
    update[DocKeyUser.preloadedTasks.name] = value;
    await FirestoreController.updateKirbyUser(
        userId: kUser.userId!, update: update);
  }

  Future<void> setNotificationsEnabled(value) async {
    var kUser = state.screenModel.kirbyUser;
    kUser!.notifications = value;
    Map<String, dynamic> update = {};
    update[DocKeyUser.notifications.name] = value;
    await FirestoreController.updateKirbyUser(
        userId: kUser.userId!, update: update);
  }
}
