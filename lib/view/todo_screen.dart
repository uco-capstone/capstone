import 'package:capstone/model/todo_item.dart';
import 'package:capstone/view/view/view_util.dart';
import 'package:flutter/material.dart';

class ToDoScreen extends StatefulWidget {
  static const routeName = '/todoScreen';

  const ToDoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ToDoScreenState();
  }
}

class _ToDoScreenState extends State<ToDoScreen> {
  late _Controller con;
  late DateTime? datePicked;
  late TimeOfDay? timePicked;
  var formKey = GlobalKey<FormState>();
  //late ToDoScreenModel screenModel;

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: const Text('To Do List'),
        actions: [
          IconButton(
            onPressed: () =>
                showSnackBar(context: context, message: 'Button Pressed'),
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      //body: const Text('To Do Items'),
      floatingActionButton:
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Form(
                    key: formKey,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Column(
                            children: [
                              Text(
                                'Add a New Task',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.purple[300],
                                    fontWeight: FontWeight.bold
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        boxShadow: [
                                          const BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 5.0,
                                            spreadRadius: 0.0,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                          hintText: "Task Name...",
                                          border: InputBorder.none,
                                        ),
                                        validator: con.validateTaskName,
                                        onSaved: con.saveTaskName,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                            child: Container(
                                              width: 150,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // ignore: prefer_const_literals_to_create_immutables
                                                boxShadow: [
                                                  const BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(0.0, 0.0),
                                                    blurRadius: 5.0,
                                                    spreadRadius: 0.0,
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: TextFormField(
                                                decoration: const InputDecoration(
                                                  hintText: "Task Date...",
                                                  border: InputBorder.none,
                                                ),
                                                controller: con.datePickedController,
                                                validator: con.validateDatePicked,
                                                onSaved: con.saveDatePicked,
                                                onTap: () async {
                                                  datePicked = await showDatePicker(
                                                    context: context, 
                                                    initialDate: DateTime.now(), 
                                                    firstDate: DateTime.now(), 
                                                    lastDate: DateTime(3000),
                                                  );
                                                  setState(() {
                                                    if(datePicked != null) {
                                                      con.datePickedController.text = '${datePicked!.month}/${datePicked!.day}/${datePicked!.year}';
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                                            child: Container(
                                              width: 150,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // ignore: prefer_const_literals_to_create_immutables
                                                boxShadow: [
                                                  const BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(0.0, 0.0),
                                                    blurRadius: 5.0,
                                                    spreadRadius: 0.0,
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: TextFormField(
                                                decoration: const InputDecoration(
                                                  hintText: "Task Time...",
                                                  border: InputBorder.none,
                                                ),
                                                controller: con.timePickedController,
                                                validator: con.validateTimePicked,
                                                onSaved: con.saveTimePicked,
                                                onTap: () async {
                                                  timePicked = await showTimePicker(
                                                    context: context, 
                                                    initialTime: TimeOfDay.now(),
                                                  );
                                                  setState(() {
                                                    if(timePicked != null) {
                                                      con.timePickedController.text = "${timePicked!.hour}:${timePicked!.minute}";
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: OutlinedButton(
                                  onPressed: () { Navigator.pop(context); },
                                  child: Text('Cancel', style: TextStyle(color: Colors.purple[200]),),
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 30, 20),
                                child: ElevatedButton(
                                  onPressed: con.addNewTask, 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple[200],
                                    elevation: 5,
                                  ),
                                  child: const Text(
                                    'Add New Task',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
            },
            backgroundColor: Colors.purple[200], 
            elevation: 10,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            child: const Text(
              '+',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
          ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.deepPurple,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(25), // padding needed
                  prefixIconConstraints: BoxConstraints(
                    maxHeight:
                        50, // this value was too small -- must be bigger than image size
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
            SingleChildScrollView(
              child: Column(
                children: [
                  ListView(
                    shrinkWrap: true,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _ToDoScreenState state;
  _Controller(this.state);

  //Used to edit the text on the textformfields
  final datePickedController = TextEditingController();  
  final timePickedController = TextEditingController();  

  String? validateTaskName(String? value) {}

  void saveTaskName(String? newValue) {}

  String? validateDatePicked(String? value) {
  }

  void saveDatePicked(String? newValue) {
  }

  String? validateTimePicked(String? value) {
  }

  void saveTimePicked(String? newValue) {
  }

  void addNewTask() {
  }
}
