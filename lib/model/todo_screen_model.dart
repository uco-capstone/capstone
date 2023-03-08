import 'package:capstone/controller/firestore_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'kirby_task_model.dart';
import 'kirby_user_model.dart';

class TodoScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;
  bool loading = false;
  

  TodoScreenModel({required this.user});

  Future<void> addPreloadedTasks() async {
    List<KirbyTask> taskList = [];
    DateTime now = DateTime.now();
    String meals = kirbyUser?.averageMealsEaten.toString() == ""
        ? "4"
        : kirbyUser!.averageMealsEaten.toString();

    KirbyTask eatMeals = KirbyTask(
        userId: user.uid,
        title: "Eat $meals meals today",
        isPreloaded: true,
        isReoccuring: true,
        // due midnight tonight
        dueDate: DateTime(now.year, now.month, now.day, 24));
    taskList.add(eatMeals);

    KirbyTask drinkWater = KirbyTask(
        userId: user.uid,
        title: "Drink ${getHalfWeight()}oz of water",
        isPreloaded: true,
        isReoccuring: true,
        // due midnight tonight
        dueDate: DateTime(now.year, now.month, now.day, 24));
    taskList.add(drinkWater);

    KirbyTask sleep = KirbyTask(
        userId: user.uid,
        title: "Sleep for ${getSleep()} hours",
        isPreloaded: true,
        isReoccuring: true,
        // due midnight tonight
        dueDate: DateTime(now.year, now.month, now.day, 24));
    taskList.add(sleep);

    // add to firebase
    for (var element in taskList) {
      await FirestoreController.addTask(kirbyTask: element);
    }
  }

  Future<List<KirbyTask>> getPreloadedTaskList() async {
    var result = await FirestoreController.getPreloadedTaskList(uid: user.uid);
    if (result.isEmpty) {
      // add preloaded tasks to firebase
      await addPreloadedTasks();
      result = await FirestoreController.getPreloadedTaskList(uid: user.uid);
    }
    return result;
  }

  String getHalfWeight() {
    if (kirbyUser?.weight != null) {
      return (kirbyUser!.weight! * 8).round().toString();
    } else {
      return "100";
    }
  }

  String getSleep() {
    if (kirbyUser?.averageSleep != null) {
      return kirbyUser!.averageSleep!.toString();
    } else {
      return "7";
    }
  }
}
