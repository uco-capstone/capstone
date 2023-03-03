import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/viewpage/view/view_util.dart';
import 'package:flutter/material.dart';

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
  void toggleSelected() {
    setState(() {
      notSelected = !notSelected;
    });
  }

  void deleteTask() {
    widget.deleteFn(widget.task.taskId!);
    setState(() {
      notSelected = !notSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.task.dueDate != null) {
      return ListTile(
        onLongPress: toggleSelected,
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
            //decoration: TextDecoration.lineThrough,
          ),
        ),
        trailing: Container(
          height: 50,
          width: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: notSelected
              ? kirbabButton(
                  context: context,
                  fn: () => showSnackBar(context: context, message: "Hi"),
                )
              : IconButton(
                  color: Colors.red,
                  icon: const Icon(Icons.delete),
                  iconSize: 17,
                  onPressed: deleteTask,
                ),
        ),
        subtitle: Text(
            dueDate()), //Text('Due: ${task.dueDate!.month}/${task.dueDate!.day}/${task.dueDate!.year} at ${task.dueDate!.hour}:${task.dueDate!.minute}'),
      );
    } else {
      return ListTile(
        onLongPress: toggleSelected,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        leading: const Icon(
          Icons.check_box,
          color: Colors.blue,
        ),
        title: Text(
          widget.task.title!,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.black,
            //decoration: TextDecoration.lineThrough,
          ),
        ),
        trailing: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: notSelected
              ? kirbabButton(
                  context: context,
                  fn: () => showSnackBar(context: context, message: "Hi"),
                )
              : IconButton(
                  color: Colors.red,
                  icon: const Icon(Icons.delete),
                  iconSize: 17,
                  onPressed: deleteTask,
                ),
        ),
      );
    }
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
