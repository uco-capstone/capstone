import 'package:capstone/model/kirby_task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'kirby_user_model.dart';

class TodoScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;
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
    );
    _tempTime = const TimeOfDay(hour: 0, minute: 0);
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
