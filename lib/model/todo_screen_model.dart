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
    );
    _tempTime = const TimeOfDay(hour: 23, minute: 59);
  }

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
      await FirestoreController.addKirbyTask(kirbyTask: element);
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

  void saveTaskName(String? value) {
    if (value != null) {
      tempTask.title = value;
    }
  }

  void saveDatePicked(String? value) {
    if (value != null) {
      var date = value.split("/");
      int day = int.parse(date[0]);
      int month = int.parse(date[1]);
      int year = int.parse(date[2]);
      tempTask.dueDate = DateTime(
        year,
        month,
        day,
        _tempTime.hour,
        _tempTime.minute,
      );
    } else {
      return;
    }
  }

  void saveTimePicked(String? value) {
    if (value != null) {
      var time = value.split(":");
      _tempTime =
          TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
    } else {
      return;
    }
  }
}
