import 'package:capstone/controller/firestore_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'kirby_task_model.dart';
import 'package:flutter/material.dart';

import 'kirby_user_model.dart';

class TodoScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;
  bool loading = false;
  var taskList = <KirbyTask>[];
  late KirbyTask tempTask;
  late TimeOfDay _tempTime;

  TodoScreenModel({required this.user}) {
    tempTask = KirbyTask(
      userId: user.uid,
      title: "",
      dueDate: null,
      isCompleted: false,
      isPreloaded: false,
      isReoccuring: false,
      isPastDue: false,
      completeDate: null,
    );
    _tempTime = const TimeOfDay(hour: 0, minute: 0);
  }

  // adds the preloaded tasks
  Future<List<KirbyTask>> addPreloadedTasks() async {
    List<KirbyTask> taskList = [];
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    String meals = kirbyUser?.averageMealsEaten.toString() == ""
        ? "4"
        : kirbyUser!.averageMealsEaten.toString();

    KirbyTask eatMeals = KirbyTask(
      userId: user.uid,
      title: "Eat $meals meals today",
      isCompleted: false,
      isPreloaded: true,
      isReoccuring: true,
      isPastDue: false,
      // due midnight tonight
      dueDate: today,
    );
    taskList.add(eatMeals);

    KirbyTask drinkWater = KirbyTask(
      userId: user.uid,
      title: "Drink ${getHalfWeight()}oz of water",
      isCompleted: false,
      isPreloaded: true,
      isReoccuring: true,
      isPastDue: false,
      // due midnight tonight
      dueDate: today,
    );
    taskList.add(drinkWater);

    KirbyTask sleep = KirbyTask(
      userId: user.uid,
      title: "Sleep for ${getSleep()} hours",
      isCompleted: false,
      isPreloaded: true,
      isReoccuring: true,
      isPastDue: false,
      // due midnight tonight
      dueDate: today,
    );
    taskList.add(sleep);

    // add to firebase
    for (var element in taskList) {
      var ref = await FirestoreController.addKirbyTask(kirbyTask: element);
      element.taskId = ref;
    }
    return taskList;
  }

  // half of the user's weight
  String getHalfWeight() {
    if (kirbyUser?.weight != null) {
      return (kirbyUser!.weight! / 2).round().toString();
    } else {
      return "100";
    }
  }

  // gets hours sleep
  String getSleep() {
    if (kirbyUser?.averageSleep != null) {
      return kirbyUser!.averageSleep!.toString();
    } else {
      return "7";
    }
  }

  // gets meals eaten
  String getMeals() {
    if (kirbyUser?.averageMealsEaten != null) {
      return kirbyUser!.averageMealsEaten!.toString();
    } else {
      return "3";
    }
  }

  // gets the Drink x oz of water preloaded task
  Future<String?> getDrinkTaskID() async {
    String target = "Drink";
    // get all preloaded tasks
    var allPreloadedTasks =
        await FirestoreController.getPreloadedTaskList(uid: user.uid);

    // parse tasks to get Drink task
    for (var task in allPreloadedTasks) {
      if (task.title!.contains(target)) {
        // get drink task ID
        return task.taskId;
      }
    }
    return null;
  }

  // updates the Drink x oz of water preloaded task
  Future<void> updateDrinkTask() async {
    String title = "Drink ${getHalfWeight()}oz of water";
    String taskID = await getDrinkTaskID() as String;
    Map<String, dynamic> update = {DocKeyKirbyTask.title.name: title};
    await FirestoreController.updateKirbyTask(taskId: taskID, update: update);
  }

  // gets the Sleep for x hours preloaded task
  Future<String?> getSleepTaskID() async {
    String target = "Sleep";
    // get all preloaded tasks
    var allPreloadedTasks =
        await FirestoreController.getPreloadedTaskList(uid: user.uid);

    // parse tasks to get Sleep task
    for (var task in allPreloadedTasks) {
      if (task.title!.contains(target)) {
        // get Sleep task ID
        return task.taskId;
      }
    }
    return null;
  }

  // updates the Sleep for x hours preloaded task
  Future<void> updateSleepTask() async {
    String title = "Sleep for ${getSleep()} hours";
    String taskID = await getSleepTaskID() as String;
    Map<String, dynamic> update = {DocKeyKirbyTask.title.name: title};
    await FirestoreController.updateKirbyTask(taskId: taskID, update: update);
  }

  // gets the Eat x meals today preloaded task
  Future<String?> getMealsTaskID() async {
    String target = "Eat";
    // get all preloaded tasks
    var allPreloadedTasks =
        await FirestoreController.getPreloadedTaskList(uid: user.uid);

    // parse tasks to get Eat task
    for (var task in allPreloadedTasks) {
      if (task.title!.contains(target)) {
        // get Eat task ID
        return task.taskId;
      }
    }
    return null;
  }

  // updates the Eat x meals today preloaded task
  Future<void> updateEatTask() async {
    String title = "Eat ${getMeals()} meals today";
    String taskID = await getMealsTaskID() as String;
    Map<String, dynamic> update = {DocKeyKirbyTask.title.name: title};
    await FirestoreController.updateKirbyTask(taskId: taskID, update: update);
  }

  void saveTaskName(String? value) {
    if (value != null) {
      tempTask.title = value;
    }
  }

  void saveDatePicked(String? value) {
    if (value != null && value != "") {
      var date = value.split("/");
      if (date.isEmpty) return;
      int month = int.parse(date[0]);
      int day = int.parse(date[1]);
      int year = int.parse(date[2]);
      tempTask.dueDate = DateTime(year, month, day);
    } else {
      return;
    }
  }

  void saveTimePicked(String? value) {
    if (value != null && value != "") {
      var time = value.split(":");
      if (time.isEmpty) return;
      _tempTime =
          TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
      combineDateAndTime();
    } else {
      _tempTime = TimeOfDay(hour: 23, minute: 59);
      combineDateAndTime();
      return;
    }
  }

  void combineDateAndTime() {
    if (tempTask.dueDate == null &&
        !(_tempTime.hour == 0 && _tempTime.minute == 0)) {
      var day = DateTime.now().day;
      var month = DateTime.now().month;
      var year = DateTime.now().year;
      tempTask.dueDate = DateTime(
        year,
        month,
        day,
        _tempTime.hour,
        _tempTime.minute,
      );
      return;
    }
    DateTime newDueDate = DateTime(
      tempTask.dueDate!.year,
      tempTask.dueDate!.month,
      tempTask.dueDate!.day,
      _tempTime.hour,
      _tempTime.minute,
    );
    tempTask.dueDate = newDueDate;
  }
}
