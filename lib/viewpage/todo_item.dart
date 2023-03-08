import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/viewpage/view/view_util.dart';
import 'package:flutter/material.dart';

enum SampleItem { delete, edit, cancel }

class ToDoItem extends StatefulWidget {
  const ToDoItem(
      {required this.task,
      required this.taskIndex,
      required this.deleteFn,
      required this.editFn,
      Key? key})
      : super(key: key);

  final Function deleteFn;
  final Function editFn;
  final KirbyTask task;
  final int taskIndex;

  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  var notSelected = true;
  SampleItem? selectedMenu;
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
    // print("got here...");
    widget.editFn(widget.task.taskId!);
    setState(() {
      notSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: toggleSelected,
      onTap: () => notSelected ? () {} : setState(() => notSelected = true),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      tileColor: Colors.white,
      leading: const Icon(
        Icons.check_box,
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
                initialValue: selectedMenu,
                onSelected: (SampleItem item) {
                  setState(() {
                    selectedMenu = item;
                    if (selectedMenu == SampleItem.delete) {
                      deleteTask();
                    } else if (selectedMenu == SampleItem.edit) {
                      // print("got here");
                      editTask();
                    }
                  });
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<SampleItem>>[
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.delete,
                    child: Text('Delete'),
                  ),
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.edit,
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.cancel,
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
          ? Text(dueDate())
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
