import 'package:capstone/model/user_model.dart';

enum DocKeyKirbyTask {
  title,
  user,
  description,
  dueDate,
}

class KirbyTask {
  String? taskId;
  KirbyUser user;
  String? title;
  String? description;
  DateTime? dueDate;

  KirbyTask({
    this.taskId,
    required this.user,
    this.title,
    this.description,
    this.dueDate,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      // DocKeyKirbyTask.user.name: user,

      DocKeyKirbyTask.user.name: {
        'userId': user.userId,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'birthday': user.birthday,
        'weight': user.weight,
        'height': user.height,
        'averageSleep': user.averageSleep,
        'averageMealsEaten': user.averageMealsEaten,
      },

      DocKeyKirbyTask.title.name: title,
      DocKeyKirbyTask.description.name: description,
      DocKeyKirbyTask.dueDate.name: dueDate,
    };
  }

  factory KirbyTask.fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String taskId,
  }) {
    return KirbyTask(
      taskId: taskId,
      user: doc[DocKeyKirbyTask.user.name] ??= "",
      title: doc[DocKeyKirbyTask.title.name] ??= "",
      description: doc[DocKeyKirbyTask.description.name] ??= "",
      dueDate: doc[DocKeyKirbyTask.dueDate.name] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              doc[DocKeyKirbyTask.dueDate.name].millisecondsSinceEpoch,
            )
          : null,
    );
  }

  static String? validateTaskName(String? value) {
    return (value == null || value.trim().length < 3) ? 'Task Name is too short.' : null;
  }

  static String? validateDatePicked(String? value) {
    if(value == null || value.trim().isEmpty) {
      return null;
    } else {
      // var dateFormat = RegExp('\d{2}/{1}\d{2}/{1}\d{4}');
      var dateFormat = RegExp(r'([0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9])');
      if (dateFormat.hasMatch(value) == false) {
        return 'Not in MM/DD/YYYY format.'; 
      } else {
        String monthsString = value.substring(0, 2);
        String daysString = value.substring(3, 5);
        int months = int.parse(monthsString);
        if(monthsString.startsWith('0')) {
          monthsString.replaceFirst(RegExp(r'0'), '');
        }
        int days = int.parse(daysString);
        if(daysString.startsWith('0')) {
          daysString.replaceFirst(RegExp(r'0'), '');
        }
        if(months < 0 || months > 12) {
          return 'Invalid month input';
        } else if (days < 0 || days > 31) {
          return 'Invalid day input.';
        } else {
          return null;
        }
      }
    }


  }

  static String? validateTimePicked(String? value) {
    if(value == null || value.trim().isEmpty) {
      return null;
    } else {
      if(value.contains(':') == false) {
        return 'Not in HH:MM format.';
      } else {
        String hoursString = value.substring(0, 2);
        if(hoursString.startsWith('0')) {
          hoursString.replaceFirst(RegExp(r'0'), '');
        }
        String minutesString = value.substring(3);
        if(minutesString.startsWith('0')) {
          minutesString.replaceFirst(RegExp(r'0'), '');
        }
        int hours = int.parse(hoursString);
        int minutes = int.parse(minutesString);
        if(hours >= 24 || hours < 0) {
          return 'Invalid hour input.';
        } else if(minutes >= 60 || minutes < 0) {
          return 'Invalid minute input.';
        } else {
          return null;
        }
      }
    }
  }
}
