import 'package:achievement_view/achievement_view.dart';
import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/viewpage/view/view_util.dart';
import 'package:flutter/material.dart';

enum TaskActions { delete, edit, cancel }

class ToDoItem extends StatefulWidget {
  const ToDoItem({
    required this.task,
    required this.taskIndex,
    required this.deleteFn,
    required this.editFn,
    Key? key,
  }) : super(key: key);

  final Function deleteFn;
  final Function editFn;
  final KirbyTask task;
  final int taskIndex;

  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  void render(fn) => setState(fn);
  var notSelected = true;
  TaskActions? taskActionMenu;

  void toggleSelected() {
    setState(() {
      notSelected = !notSelected;
    });
  }

  void deleteTask() {
    showDialogBox(
      context: context,
      title: "Delete Task",
      content: "Are you sure you want to delete this task?",
      buttonName: "Yes",
      fn: () => widget.deleteFn(widget.task.taskId!),
    );
    setState(() {
      notSelected = true;
    });
  }

  void editTask() {
    widget.editFn(widget.task.taskId!);
    setState(() {
      notSelected = true;
    });
  }

  void showAchievementView(String taskName) {
    AchievementView(context,
            title: "Good Job! +1 Hunger +100 Coins",
            subTitle: "You completed: $taskName!",
            icon: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset('images/kirby_icon.png'),
            ),
            listener: (status) {})
        .show();
  }

  @override
  Widget build(BuildContext context) {
    widget.task.isPreloaded ??= false;

    return ListTile(
      onLongPress: toggleSelected,
      onTap: () => notSelected ? () {} : setState(() => notSelected = true),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      tileColor: Colors.white,
      leading: IconButton(
        onPressed: widget.task.isCompleted
            ? null
            : () async {
                await FirestoreController.updateTaskCompletion(
                  taskId: widget.task.taskId!,
                  isCompleted: widget.task.isCompleted,
                  completeDate: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                  ),
                );
                if (!widget.task.isCompleted) {
                  showAchievementView(widget.task.title ?? "a Task");
                }

                render(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },
        icon: widget.task.isCompleted
            ? const Icon(Icons.check_box)
            : const Icon(Icons.check_box_outline_blank),
        color: Colors.blue,
      ),
      title: Text(
        widget.task.title!,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
      ),
      trailing: Container(
        height: 40,
        width: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: notSelected
            ? PopupMenuButton(
                initialValue: taskActionMenu,
                onSelected: (TaskActions item) {
                  setState(() {
                    taskActionMenu = item;
                    if (taskActionMenu == TaskActions.delete) {
                      deleteTask();
                    } else if (taskActionMenu == TaskActions.edit) {
                      editTask();
                    }
                  });
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<TaskActions>>[
                  const PopupMenuItem<TaskActions>(
                    value: TaskActions.delete,
                    child: Text('Delete'),
                  ),
                  PopupMenuItem<TaskActions>(
                    value: TaskActions.edit,
                    enabled: !widget.task.isPreloaded!,
                    child: const Text('Edit'),
                  ),
                  const PopupMenuItem<TaskActions>(
                    value: TaskActions.cancel,
                    child: Text('Cancel'),
                  ),
                ],
              )
            : IconButton(
                color: Colors.red,
                icon: const Icon(Icons.delete),
                iconSize: 17,
                onPressed: deleteTask,
              ),
      ),
      subtitle: widget.task.dueDate != null
          ? Text(dueDate(),
              style: widget.task.isPastDue!
                  ? const TextStyle(color: Colors.red)
                  : const TextStyle(color: Colors.grey))
          : const SizedBox.shrink(),
    );
  }

  String dueDate() {
    var today = DateTime.now();
    var month = widget.task.dueDate!.month;
    var day = widget.task.dueDate!.day;
    var year = widget.task.dueDate!.year;
    var hour = widget.task.dueDate!.hour;
    var minute = widget.task.dueDate!.minute;

    String dueDate = 'Due: $month/$day/$year';
    if (month == today.month && day == today.day && year == today.year) {
      dueDate = "Due Today";
    }

    if (!(hour == 0 && minute == 0)) {
      dueDate += ' at ';
      if (widget.task.dueDate!.hour < 10) {
        dueDate += '0$hour:';
      } else {
        dueDate += '$hour:';
      }

      if (widget.task.dueDate!.minute < 10) {
        dueDate += '0$minute';
      } else {
        dueDate += '$minute';
      }
    }
    return dueDate;
  }
}
