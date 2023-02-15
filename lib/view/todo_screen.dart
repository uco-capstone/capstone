import 'package:flutter/material.dart';

class ToDoScreen extends StatelessWidget {
  static const routeName = '/todoScreen';

  const ToDoScreen({Key? key}) : super(key: key); //constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Row(
          children: const [
            Icon(
              Icons.menu,
              color: Colors.black,
            ),
            Text(
              'To Do List',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      //body: const Text('List begins here'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        child: Column(
          children: [
            searchBox(),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 50,
                      bottom: 20,
                    ),
                    child: const Text(
                      'My ToDos',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget searchBox() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: Colors.black,
          size: 25,
        ),
        prefixIconConstraints: BoxConstraints(
          maxHeight: 20,
          minWidth: 25,
        ),
        border: InputBorder.none,
        hintText: ('Search Here'),
      ),
    ),
  );
}
