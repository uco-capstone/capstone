import 'package:firebase_auth/firebase_auth.dart';

import '../controller/firestore_controller.dart';
import 'kirby_task_model.dart';
import 'kirby_user_model.dart';

class LeaderboardScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;
  bool loading = false;
  List<KirbyUser> leaders = [];
  List<RankCard> ranks = [];

  LeaderboardScreenModel({required this.user});

  // setup screen model
  Future<void> setupScreen() async {
    await setLeaders();
    await setStreaks();
    await setRanks();
  }

  // get the current date without hours or minutes
  DateTime getTodayDate() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return date;
  }

  // get all users
  Future<void> setLeaders() async {
    leaders = await FirestoreController.getKirbyUserList();
  }

  // calculate the streak for a user
  Future<int> getStreak(String uid) async {
    int streak = 0;
    DateTime day = getTodayDate();

    // check if all tasks for today is completed
    List<KirbyTask> tasks =
        await FirestoreController.getDayTasks(uid: uid, day: day);
    // check if all task were completed
    while (tasks.isNotEmpty) {
      for (var task in tasks) {
        if (task.isCompleted) {
          continue;
        } else {
          if (day != getTodayDate()) {
            // there is still time to complete today's task, so don't factor today into the streak
            return streak;
          }
        }
      }
      // all tasks were completed, so increment streak
      streak++;

      // check if all tasks for previous days are completed
      day = day.add(const Duration(days: 1));
      tasks = await FirestoreController.getDayTasks(uid: uid, day: day);
    }

    return streak;
  }

  // calculate streak for all users
  Future<void> setStreaks() async {
    for (var leader in leaders) {
      ranks.add(RankCard(
        uid: leader.userId!,
        firstName: leader.firstName,
        streak: await getStreak(leader.userId!),
      ));
    }
  }

  // calculate rank for all users
  Future<void> setRanks() async {
    int rank = 1;
    int streak;
    int tie = 0;

    // order ranks by streaks
    ranks.sort((b, a) => a.streak.compareTo(b.streak));

    // get highest streak
    streak = ranks[0].streak;

    // determine rank
    for (var r in ranks) {
      if (r.streak == streak) {
        r.rank = rank;
        tie++;
      } else {
        rank += tie;
        r.rank = rank;
        tie = 0;
      }
    }
  }
}

class RankCard {
  String uid;
  String firstName;
  int streak;
  int rank;

  RankCard({
    required this.uid,
    required this.firstName,
    this.streak = 0,
    this.rank = 0,
  });

  String getUid() {
    return uid;
  }
}
