import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/model/constants.dart';
import 'package:capstone/model/kirby_user_model.dart';
import 'package:capstone/model/history_screen_model.dart';
import 'package:capstone/viewpage/health_info_screen.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';

class HistoryScreen extends StatefulWidget {
  static const routeName = "/history";
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HistoryState();
  }
}

class _HistoryState extends State<HistoryScreen> {
  late _Controller con;
  late HistoryScreenModel screenModel;
  String title = "History";

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = HistoryScreenModel(user: Auth.user!);
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
      appBar: AppBar(title: const Text("History")),
      body: screenModel.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : historyScreenBody(),
    );
  }

  Widget historyScreenBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [],
      ),
    );
  }
}

class _Controller {
  _HistoryState state;
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
}
