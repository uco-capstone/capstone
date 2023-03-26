import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/model/constants.dart';
import 'package:capstone/model/home_screen_model.dart';
import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/model/kirby_user_model.dart';
import 'package:chart_components/chart_components.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../model/history_screen_model.dart';

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
    con.initScreen();
    screenModel.setCompletionRating();
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
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.only(bottom: 200, left: 8, right: 8, top: 20),
        // decoration: BoxDecoration(
        //   shape: BoxShape.rectangle,
        //   borderRadius: BorderRadius.all(Radius.circular(10)),
        //   border: Border.all(color: Theme.of(context).primaryColor),
        // ),
        child: BarChart(
          data: [0, 1, 2, 3, 4, 5, screenModel.todayRate],
          // labels: ["Su", "M", "Tu", "W", "Th", "F", "Sa"],
          labels: screenModel.getDays(),
          displayValue: true,
          // labelStyle: TextStyle(fontSize: 18),
          // valueStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          reverse: true,
          getColor: con.getColor,
          getIcon: con.getIcon,
          barWidth: 38,
          barSeparation: 12,
          animationDuration: Duration(milliseconds: 1800),
          animationCurve: Curves.easeInOutSine,
          itemRadius: 30,
          iconHeight: 24,
          footerHeight: 24,
          headerValueHeight: 16,
          roundValuesOnText: false,
          lineGridColor: Colors.lightBlue,
        ),
      ),
    );
  }
}

class _Controller {
  _HistoryState state;
  _Controller(this.state);
  // late double _todayRate;

  void initScreen() async {
    state.screenModel.loading = true;
    await state.screenModel.setCompletionRating();
    state.screenModel.loading = false;
  }

  // // gets the days of the week, starting with the oldest, ending with today
  // List<String> getDays() {
  //   List<String> week = ["M", "Tu", "W", "Th", "F", "Sa", "Su"];

  //   int weekday = DateTime.now().weekday; // monday = 1; sunday = 7

  //   // set today as the last day of the list & reorder
  //   if (weekday == 7) {
  //     return week;
  //   } else {
  //     List<String> frontList = week.sublist(weekday);
  //     List<String> backList = week.sublist(0, weekday);
  //     week = frontList + backList;
  //     return week;
  //   }
  // }

  // // get the 1st millisecondsSinceEpoch of the day
  // int getMidnightToday() {
  //   const int msPerDay = 86400000; // 86,400,000 milliseconds/day
  //   int now = DateTime.now().millisecondsSinceEpoch;
  //   // get the 1st millisecondsSinceEpoch of the day
  //   int midnight = now % msPerDay;
  //   return midnight;
  // }

  // // rates the completion rate from 0-5
  // void setCompletionRating() async {
  //   // get all tasks for that day
  //   var results = await FirestoreController.getDayTasks(
  //     uid: Auth.getUser().uid,
  //     dateInMilli: getMidnightToday(),
  //   );
  //   if (results.isEmpty) {
  //     _todayRate = 0;
  //   } else {
  //     // calculate percent complete
  //     int completed = 0;
  //     for (var result in results) {
  //       if (result.isCompleted == true) completed++;
  //     }
  //     double rating = completed / results.length;
  //     _todayRate = rating;
  //   }
  // }

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

  // assigns color of bars
  Color getColor(double value) {
    if (value < 2) {
      return Colors.amber.shade300;
    } else if (value < 4) {
      return Colors.amber.shade600;
    } else
      return Colors.amber.shade900;
  }

  // returns star fill grades
  Icon getIcon(double value) {
    if (value < 1) {
      return Icon(
        Icons.star_border,
        size: 24,
        color: getColor(value),
      );
    } else if (value < 3) {
      return Icon(
        Icons.star_half,
        size: 24,
        color: getColor(value),
      );
    } else
      return Icon(
        Icons.star,
        size: 24,
        color: getColor(value),
      );
  }
}
