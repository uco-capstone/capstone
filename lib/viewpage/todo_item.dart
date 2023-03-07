import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/viewpage/view/view_util.dart';
import 'package:flutter/material.dart';

enum SampleItem { delete, edit, cancel }

class ToDoItem extends StatefulWidget {
  const ToDoItem(
      {required this.task,
      required this.taskIndex,
      required this.deleteFn,
      Key? key})
      : super(key: key);

  final Function deleteFn;
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
    showDialogBox(
      context: context,
      title: "Edit Task",
      content: "Are you sure you want to edit this task?",
      buttonName: "Yes",
      fn: () {},
    );
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
    String dueDate =
        'Due: ${widget.task.dueDate!.month}/${widget.task.dueDate!.day}/${widget.task.dueDate!.year}';

    if (widget.task.dueDate!.hour == 0 && widget.task.dueDate!.minute == 0) {
      return dueDate;
    } else {
      dueDate += ' at ';
      if (widget.task.dueDate!.hour < 10) {
        dueDate += '0${widget.task.dueDate!.hour}:';
      } else {
        dueDate += '${widget.task.dueDate!.hour}:';
      }

      if (widget.task.dueDate!.minute < 10) {
        dueDate += '0${widget.task.dueDate!.minute}';
      } else {
        dueDate += '${widget.task.dueDate!.minute}';
      }
      return dueDate;
    }
  }
}
