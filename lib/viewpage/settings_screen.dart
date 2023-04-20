import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/model/constants.dart';
import 'package:capstone/model/kirby_user_model.dart';
import 'package:capstone/model/settings_screen_model.dart';
import 'package:capstone/viewpage/health_info_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green],
            ),
          ),
        ),
      ),
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
          const SizedBox(
            height: 50,
          ),
          Center(
            child: SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: con.healthInfoScreen,
                child: const Text("Update Personal Info"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _SettingsState state;
  _Controller(this.state);

  // gets the Kirby user
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

  // enables/disables preloaded tasks
  Future<void> setPreloadedTasksEnabled(value) async {
    var kUser = state.screenModel.kirbyUser;
    kUser!.preloadedTasks = value;
    Map<String, dynamic> update = {};
    update[DocKeyUser.preloadedTasks.name] = value;
    await FirestoreController.updateKirbyUser(
      userId: kUser.userId!,
      update: update,
    );
  }

  // enables/disbales notifications
  Future<void> setNotificationsEnabled(value) async {
    var kUser = state.screenModel.kirbyUser;
    kUser!.notifications = value;
    Map<String, dynamic> update = {};
    update[DocKeyUser.notifications.name] = value;
    await FirestoreController.updateKirbyUser(
      userId: kUser.userId!,
      update: update,
    );
  }

  void healthInfoScreen() async {
    await Navigator.pushNamed(state.context, HealthInfoScreen.routeName);
  }
}
