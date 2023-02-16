import 'package:capstone/model/todo_item.dart';
import 'package:capstone/view/view/view_util.dart';
import 'package:flutter/material.dart';

class ToDoScreen extends StatelessWidget {
  static const routeName = '/todoScreen';

  const ToDoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: const Text('TO DO MENU'),
        actions: [
          IconButton(
            onPressed: () =>
                showSnackBar(context: context, message: 'Button Pressed'),
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      //body: const Text('To Do Items'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    size: 25,
                    color: Colors.deepPurple,
                  ),
                  contentPadding: EdgeInsets.all(0),
                  prefixIconConstraints: BoxConstraints(
                    maxHeight: 10,
                    minWidth: 25,
                  ),
                  border: InputBorder.none,
                  hintText: 'Search Keywords',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 50,
                      bottom: 20,
                    ),
                    child: const Text(
                      'All ToDos',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const ToDoItem(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
