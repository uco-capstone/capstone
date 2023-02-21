import 'dart:developer';

import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  var formKey = GlobalKey<FormState>();
  String title = "Settings";
  // final TextEditingController ageController = TextEditingController();
  // final TextEditingController weightController = TextEditingController();
  // final TextEditingController heightController = TextEditingController();
  // final TextEditingController sleepController = TextEditingController();
  // final TextEditingController mealsController = TextEditingController();

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
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Preloaded Tasks'),
            value: _preloadedTasksEnabled,
            onChanged: (value) {
              setState(() {
                _preloadedTasksEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Notifications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
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
  KirbyUser tempKirbyUser = KirbyUser(
      userId: Auth.getUser().uid,
      firstName: Auth.getUser().displayName == null
          ? ""
          : Auth.getUser().displayName!);

  Future<void> findKirbyUser() async {
    KirbyUser pulledUser =
        await FirestoreController.getKirbyUser(userId: Auth.getUser().uid);
    tempKirbyUser = pulledUser;
    state.ageController.text = state.con.tempKirbyUser.age.toString() == "null"
        ? ""
        : state.con.tempKirbyUser.age.toString();
    state.weightController.text =
        state.con.tempKirbyUser.weight.toString() == "null"
            ? ""
            : state.con.tempKirbyUser.weight.toString();
    state.heightController.text =
        state.con.tempKirbyUser.height.toString() == "null"
            ? ""
            : state.con.tempKirbyUser.height.toString();
    state.sleepController.text =
        state.con.tempKirbyUser.averageSleep.toString() == "null"
            ? ""
            : state.con.tempKirbyUser.averageSleep.toString();
    state.mealsController.text =
        state.con.tempKirbyUser.averageMealsEaten.toString() == "null"
            ? ""
            : state.con.tempKirbyUser.averageMealsEaten.toString();
  }

  // void save() async {
  //   FormState? currentState = state.formKey.currentState;
  //   if (currentState == null || !currentState.validate()) {
  //     return;
  //   }
  //   currentState.save();

  //   try {
  //     await FirestoreController.addSettings(kirbyUser: tempKirbyUser);
  //     state.showSnackBar("Success!");
  //   } catch (e) {
  //     state.showSnackBar("Error: $e");
  //   }
  // }

  void saveAge(String? value) {
    if (value != null) {
      tempKirbyUser.age = int.parse(value);
    }
  }

  void saveWeight(String? value) {
    if (value != null) {
      tempKirbyUser.weight = double.parse(value);
    }
  }

  void saveHeight(String? value) {
    if (value != null) {
      tempKirbyUser.height = int.parse(value);
    }
  }

  void saveSleep(String? value) {
    if (value != null) {
      tempKirbyUser.averageSleep = int.parse(value);
    }
  }

  void saveMeals(String? value) {
    if (value != null) {
      tempKirbyUser.averageMealsEaten = int.parse(value);
    }
  }

  // Pull Information

  // Submit Information
}
