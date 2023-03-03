import 'package:capstone/model/kirby_task_model.dart';
import 'package:flutter/material.dart';

class ToDoItem extends StatelessWidget {
  const ToDoItem({required this.task, Key? key}) : super(key: key);

  final KirbyTask task;

  @override
  Widget build(BuildContext context) {
    if(task.dueDate != null) {
      return ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: Colors.white,
        leading: const Icon(
          Icons.check_box,
          color: Colors.blue,
        ),
        title: Text(
          task.title!,
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
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.delete),
            iconSize: 17,
            onPressed: () {},
          ), 
        ),
        subtitle: Text(dueDate()),//Text('Due: ${task.dueDate!.month}/${task.dueDate!.day}/${task.dueDate!.year} at ${task.dueDate!.hour}:${task.dueDate!.minute}'),
      );
    } else {
      return ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: Colors.white,
        leading: const Icon(
          Icons.check_box,
          color: Colors.blue,
        ),
        title: Text(
          task.title!,
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
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.delete),
            iconSize: 17,
            onPressed: () {},
          ),
        ),
      );
    }
  }
  
  String dueDate() {
    String dueDate = 'Due: ${task.dueDate!.month}/${task.dueDate!.day}/${task.dueDate!.year}';

    if(task.dueDate!.hour == 0 && task.dueDate!.minute == 0) {
      return dueDate;
    } else {
      dueDate += ' at ';
      if(task.dueDate!.hour < 10) {
        dueDate += '0${task.dueDate!.hour}:';
      } else {
        dueDate += '${task.dueDate!.hour}:';
      }

      if(task.dueDate!.minute < 10) {
        dueDate += '0${task.dueDate!.minute}';
      } else {
        dueDate += '${task.dueDate!.minute}';
      }
      return dueDate;
    }
  }
}
