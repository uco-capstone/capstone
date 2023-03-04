enum DocKeyKirbyTask {
  taskId,
  title,
  user,
  userId,
  dueDate,
  isCompleted,
  isPreloaded,
  isReoccuring,
}

class KirbyTask {
  String? taskId;
  String userId;
  String? title;
  DateTime? dueDate;
  bool isCompleted;
  bool? isPreloaded;
  bool? isReoccuring;

  KirbyTask({
    this.taskId,
    required this.userId,
    this.title,
    this.dueDate,
    required this.isCompleted,
    this.isPreloaded,
    this.isReoccuring,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyKirbyTask.userId.name: userId,
      DocKeyKirbyTask.title.name: title,
      DocKeyKirbyTask.dueDate.name: dueDate,
      DocKeyKirbyTask.isCompleted.name: isCompleted,
      DocKeyKirbyTask.isPreloaded.name: isPreloaded,
      DocKeyKirbyTask.isReoccuring.name: isReoccuring,
    };
  }

  factory KirbyTask.fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String taskId,
  }) {
    return KirbyTask(
      taskId: taskId,
      userId: doc[DocKeyKirbyTask.userId.name] ??= "",
      title: doc[DocKeyKirbyTask.title.name] ??= "",
      dueDate: doc[DocKeyKirbyTask.dueDate.name] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              doc[DocKeyKirbyTask.dueDate.name].millisecondsSinceEpoch,
            )
          : null,
      isCompleted: doc[DocKeyKirbyTask.isCompleted.name] ??= false,
      isPreloaded: doc[DocKeyKirbyTask.isPreloaded.name] ??= false,
      isReoccuring: doc[DocKeyKirbyTask.isReoccuring.name] ??= false,
    );
  }

  //Input Validation

  static String? validateTaskName(String? value) {
    return (value == null || value.trim().length < 3)
        ? 'Task Name is too short.'
        : null;
  }

  static String? validateDatePicked(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    } else {
      // var dateFormat = RegExp('\d{2}/{1}\d{2}/{1}\d{4}');
      var dateFormat = RegExp(r'([0-9]{1,2}/[0-9]{1,2}/[0-9][0-9][0-9][0-9])');
      if (dateFormat.hasMatch(value) == false) {
        return 'Not in MM/DD/YYYY format.';
      } else {
        var dateArray = value.split('/');
        int months = int.parse(dateArray[0]);
        int days = int.parse(dateArray[1]);

        if (months <= 0 || months > 12) {
          return 'Invalid month input';
        } else if (days <= 0 || days > 31) {
          return 'Invalid day input.';
        } else if (dateArray[2].length < 4 || dateArray[2].length > 5) {
          return 'Invalid year input.';
        } else {
          return null;
        }
      }
    }
  }

  static String? validateTimePicked(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    } else {
      var timeFormat = RegExp(r'([0-9][0-9]:[0-9][0-9])');
      if (timeFormat.hasMatch(value) == false) {
        return 'Not in HH:MM format.';
      } else {
        var timeArray = value.split(':');
        String hoursString = timeArray[0];
        if (hoursString.startsWith('0')) {
          hoursString.replaceFirst(RegExp(r'0'), '');
        }
        String minutesString = timeArray[1];
        if (minutesString.startsWith('0')) {
          minutesString.replaceFirst(RegExp(r'0'), '');
        }
        int hours = int.parse(hoursString);
        int minutes = int.parse(minutesString);
        if (hours >= 24 || hours < 0) {
          return 'Invalid hour input.';
        } else if (minutes >= 60 || minutes < 0) {
          return 'Invalid minute input.';
        } else {
          return null;
        }
      }
    }
  }
}
