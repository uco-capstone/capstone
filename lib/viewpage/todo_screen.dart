import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/viewpage/todo_item.dart';
import 'package:capstone/viewpage/view/view_util.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../model/constants.dart';

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
  DateTime? datePicked;
  TimeOfDay? timePicked;
  var taskList = <KirbyTask>[];
  var formKey = GlobalKey<FormState>();
  //late ToDoScreenModel screenModel;

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    //con.getKirbyUser();
    con.getTaskList();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 20,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SizedBox(
                    height: 400,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Add a New Task',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.purple[300],
                                  fontWeight: FontWeight.bold),
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
                                      validator: KirbyTask.validateTaskName,
                                      onSaved: con.saveTaskName,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 30, 0, 0),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                hintText: "Task Date...",
                                                border: InputBorder.none,
                                              ),
                                              controller:
                                                  con.datePickedController,
                                              validator:
                                                  KirbyTask.validateDatePicked,
                                              onSaved: con.saveDatePicked,
                                              onTap: () async {
                                                datePicked =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(3000),
                                                );
                                                setState(() {
                                                  if (datePicked != null) {
                                                    con.datePickedController
                                                            .text =
                                                        '${datePicked!.month}/${datePicked!.day}/${datePicked!.year}';
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
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 30, 0, 0),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                hintText: "Task Time...",
                                                border: InputBorder.none,
                                              ),
                                              controller:
                                                  con.timePickedController,
                                              validator:
                                                  KirbyTask.validateTimePicked,
                                              onSaved: con.saveTimePicked,
                                              onTap: () async {
                                                timePicked =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                );
                                                setState(() {
                                                  if (timePicked != null) {
                                                    con.timePickedController
                                                            .text =
                                                        "${(timePicked!.hour < 10) ? '0${timePicked!.hour}' : timePicked!.hour}:${(timePicked!.minute < 10) ? '0${timePicked!.minute}' : timePicked!.minute}";
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
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      con.datePickedController.clear();
                                      con.timePickedController.clear();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style:
                                          TextStyle(color: Colors.purple[200]),
                                    ),
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 30, 20),
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
                  ),
                ),
              );
            },
            isScrollControlled: true,
          );
        },
        backgroundColor: Colors.purple[200],
        elevation: 10,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: const Text(
          '+',
          style: TextStyle(
            fontSize: 32,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
              taskList.isEmpty
                  ? Center(
                      child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 75, bottom: 40),
                          child: SizedBox(
                            height: 200,
                            child:
                                Image.asset('images/kirby-happy-jumping.png'),
                          ),
                        ),
                        const Text(
                          'All Tasks Completed!\nGreat Job!',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ))
                  : Column(
                      children: [
                        SizedBox(
                          height: 500,
                          child: ListView(
                            //shrinkWrap: true,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 50,
                                  bottom: 20,
                                ),
                                child: const Text(
                                  'All Tasks',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  for (var t in taskList)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: ToDoItem(task: t),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _ToDoScreenState state;
  KirbyTask tempTask = KirbyTask(userId: Auth.getUser().uid);
  //late KirbyUser kirbyUser;
  late String dueDateString;
  _Controller(this.state);

  //Used to edit the text on the textformfields
  final datePickedController = TextEditingController();
  final timePickedController = TextEditingController();

  // void getKirbyUser() async {
  //   kirbyUser =
  //       await FirestoreController.getKirbyUser(userId: Auth.getUser().uid);
  //   tempTask = KirbyTask(user: kirbyUser);
  // }

  void saveTaskName(String? newValue) {
    if (newValue != null) {
      tempTask.title = newValue;
    }
  }

  void saveDatePicked(String? newValue) {
    if (newValue != null && state.datePicked != null) {
      tempTask.dueDate = state.datePicked;
    } else {
      return;
    }
  }

  void saveTimePicked(String? newValue) {
    if (newValue != null &&
        state.timePicked != null &&
        state.datePicked != null) {
      var tempDueDate = DateTime(
          state.datePicked!.year,
          state.datePicked!.month,
          state.datePicked!.day,
          state.timePicked!.hour,
          state.timePicked!.minute);
      tempTask.dueDate = tempDueDate;
    }
  }

  void addNewTask() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) {
      return;
    }

    if (state.datePicked == null && state.timePicked != null) {
      showDialog(
          context: state.context,
          builder: (context) => AlertDialog(
                title: const Text('Kirby Spotted An Error!'),
                content: const Text(
                    'Must choose a date in order to add a time. \n\nTo create a task, either add a date, or remove the time!'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(state.context).pop();
                    },
                  ),
                ],
              ));
    }

    currentState.save();

    try {
      tempTask.userId = Auth.getUser().uid;
      // ignore: unused_local_variable
      String docID = await FirestoreController.addTask(kirbyTask: tempTask);
      state.render(() {
        state.taskList.add(tempTask);
      });
      datePickedController.clear();
      timePickedController.clear();
      if (state.mounted) {
        Navigator.pop(state.context);
        showSnackBar(
            context: state.context, seconds: 20, message: 'Task Added!');
      }
    } catch (e) {
      Navigator.pop(state.context);
      // ignore: avoid_print
      if (Constants.devMode) print('************* Add KirbyTask Error: $e');
      showSnackBar(
          context: state.context,
          seconds: 20,
          message: 'Add KirbyTask Error: $e');
    }
  }

  void getTaskList() async {
    state.taskList =
        await FirestoreController.getKirbyTaskList(uid: Auth.getUser().uid);
    state.render(() {});
  }
}
