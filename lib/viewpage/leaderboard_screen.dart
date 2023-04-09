import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/model/constants.dart';
import 'package:capstone/viewpage/rank_item.dart';
import 'package:chart_components/chart_components.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../model/leaderboard_screen_model.dart';

class LeaderboardScreen extends StatefulWidget {
  static const routeName = "/leaderboard";
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LeaderboardState();
  }
}

class _LeaderboardState extends State<LeaderboardScreen> {
  late _Controller con;
  late LeaderboardScreenModel screenModel;
  String title = "Leaderboard";

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = LeaderboardScreenModel(user: Auth.user!);
    con.initScreen();
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
      appBar: AppBar(title: const Text("Leaderboard")),
      body: screenModel.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : LeaderboardScreenBody(),
    );
  }

  Widget LeaderboardScreenBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          margin: const EdgeInsets.all(16),
          padding:
              const EdgeInsets.only(bottom: 200, left: 8, right: 8, top: 20),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              Column(
                children: [
                  for (var r in screenModel.ranks)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RankItem(
                        uid: r.uid,
                        // taskIndex: screenModel.taskList.indexOf(t),
                        firstName: r.firstName,
                        streak: r.streak,
                        rank: r.rank,
                      ),
                    ),
                ],
              )
            ],
          )),
    );
  }
}

class _Controller {
  _LeaderboardState state;
  _Controller(this.state);

  // gets user info
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

  void initScreen() async {
    state.screenModel.loading = true;
    await state.screenModel.setupScreen();

    state.render(() {});

    state.screenModel.loading = false;
  }
}