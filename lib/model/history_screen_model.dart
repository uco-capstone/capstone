import 'package:firebase_auth/firebase_auth.dart';

import '../controller/firestore_controller.dart';
import 'kirby_user_model.dart';

class HistoryScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;
  bool loading = false;
  late double todayRate;
  int scale = 5;
  List<double> completionRatings = [];

  HistoryScreenModel({required this.user});

// gets the days of the week, starting with the oldest, ending with today
  List<String> getDays() {
    List<String> week = ["M", "Tu", "W", "Th", "F", "Sa", "Su"];

    int weekday = DateTime.now().weekday; // monday = 1; sunday = 7

    // set today as the last day of the list & reorder
    if (weekday == 7) {
      return week;
    } else {
      List<String> frontList = week.sublist(weekday);
      List<String> backList = week.sublist(0, weekday);
      week = frontList + backList;
      return week;
    }
  }

// get the 1st millisecondsSinceEpoch of the day
  int getMidnightToday() {
    const int msPerDay = 86400000; // 86,400,000 milliseconds/day
    int now = DateTime.now().millisecondsSinceEpoch;
    // get the 1st millisecondsSinceEpoch of the day
    int midnight = now - (now % msPerDay);
    return midnight;
  }

  DateTime getTodayDate() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return date;
  }

// sets the completion ratings for the week
  Future<void> setCompletionRatings() async {
    List<double> data = [];
    for (int i = 6; i >= 0; i--) {
      // get all tasks from the given day
      var results = await FirestoreController.getDayTasks(
          uid: user.uid, day: getTodayDate().subtract(Duration(days: i)));
      if (results.isEmpty) {
        data.add(0);
      } else {
        // calculate percent complete
        int completed = 0;
        for (var result in results) {
          if (result.isCompleted == true) completed++;
        }
        double rating = completed * scale / results.length;
        data.add(double.parse((rating).toStringAsFixed(1)));
      }
    }
    completionRatings = data;
  }

// // rates the completion rate from 0-5 for the given date
//   Future<double> getRating(DateTime day) async {
//     // get all tasks for that day
//     var results = await FirestoreController.getDayTasks(
//         uid: user.uid,
//         // dateInMilli: getMidnightToday(),
//         day: day);
//     if (results.isEmpty) {
//       return 0;
//     } else {
//       // calculate percent complete
//       int completed = 0;
//       for (var result in results) {
//         if (result.isCompleted == true) completed++;
//       }
//       double rating = completed * scale / results.length;
//       return rating;
//     }
//   }

//   Future<void> setData() async {
//     double rating = await getRating(getTodayDate());
//     data = [0, 1, 2, 3, 4, rating, todayRate];
//   }
}
