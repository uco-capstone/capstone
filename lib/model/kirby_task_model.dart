import 'package:capstone/model/user_model.dart';

enum DocKeyKirbyTask {
  title,
  user,
  description,
  dueDate,
}

class KirbyTask {
  String? taskId;
  User user;
  String title;
  String? description;
  DateTime? dueDate;

  KirbyTask({
    this.taskId,
    required this.user,
    required this.title,
    this.description,
    this.dueDate,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyKirbyTask.user.name: user,
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
}
