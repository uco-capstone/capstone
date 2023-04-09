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
    await orderTies();
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
    bool completedTodaysTasks = true;
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
          if (day == getTodayDate()) {
            // there is still time to complete today's task, so don't factor today into the streak
            completedTodaysTasks = false;
          } else {
            // not today
            return streak;
          }
        }
      }
      // all tasks were completed, so increment streak
      streak++;

      // check if all tasks for previous days are completed
      day = day.subtract(const Duration(days: 1));
      tasks = await FirestoreController.getDayTasks(uid: uid, day: day);
    }

    if (completedTodaysTasks == false) streak--;

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
        tie == 0 ? rank++ : rank += tie;
        r.rank = rank;
        tie = 0;
        streak = r.streak;
      }
    }
  }

// alphabetically order a sublist of rank
  void orderSublist(int i, int ties) {
    // get the tied sublist
    int startRange = i - 1 - ties;
    int endRange = i;
    List<RankCard> tiedCards = ranks.sublist(startRange, endRange);
    tiedCards.sort((a, b) => a.firstName.compareTo(b.firstName));

    // replace sublist
    ranks.replaceRange(startRange, endRange, tiedCards);
  }

// sort ties alphabetically
  Future<void> orderTies() async {
    int tempRank = ranks[0].rank;
    int ties = 0;
    for (var i = 1; i < ranks.length; i++) {
      // find ties
      if (tempRank == ranks[i].rank) {
        // same rank as previous rank item
        ties++;
      } else if (ties > 0) {
        // current ranks are not tied
        // order previous set of ties
        orderSublist(i, ties);

        ties = 0;
      }
      tempRank = ranks[i].rank;

      // if last user is tied
      if (i == ranks.length - 1 && ties > 0) {
        orderSublist(i + 1, ties);
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
