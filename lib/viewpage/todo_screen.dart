import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/model/todo_screen_model.dart';
import 'package:capstone/viewpage/todo_item.dart';
import 'package:capstone/viewpage/view/view_util.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';

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
  var formKey = GlobalKey<FormState>();
  late TodoScreenModel screenModel;

  void render(fn) => setState(fn);


  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = TodoScreenModel(user: Auth.getUser());
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
      floatingActionButton: addTaskButton(),
      body: body(),
    );
  }

  Widget addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.only(
                    top: 20, bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                  height: 400,
                  child: addTaskBody(),
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
    );
  }

  Widget addTaskBody() {
    return Stack(
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
              child: addTaskInputs(),
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
                      style: TextStyle(color: Colors.purple[200]),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 30, 20),
                child: ElevatedButton(
                  onPressed: con.save,
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
    );
  }

  Widget addTaskInputs() {
    return Column(
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
            onSaved: screenModel.saveTaskName,
          ),
        ),
        Row(
          children: [
            addTaskDateInput(),
            addTaskTimeInput(),
          ],
        ),
      ],
    );
  }

  Widget addTaskDateInput() {
    return Expanded(
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
            validator: KirbyTask.validateDatePicked,
            onSaved: screenModel.saveDatePicked,
            onTap: () async {
              datePicked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(3000),
              );
              setState(() {
                if (datePicked != null) {
                  con.datePickedController.text =
                      '${datePicked!.month}/${datePicked!.day}/${datePicked!.year}';
                }
              });
            },
          ),
        ),
      ),
    );
  }

  Widget addTaskTimeInput() {
    return Expanded(
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
            validator: KirbyTask.validateTimePicked,
            onSaved: screenModel.saveTimePicked,
            onTap: () async {
              timePicked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              setState(() {
                if (timePicked != null) {
                  con.timePickedController.text =
                      "${(timePicked!.hour < 10) ? '0${timePicked!.hour}' : timePicked!.hour}:${(timePicked!.minute < 10) ? '0${timePicked!.minute}' : timePicked!.minute}";
                }
              });
            },
          ),
        ),
      ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
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
            screenModel.taskList.isEmpty ? emptyTaskList() : tasks(),
          ],
        ),
      ),
    );
  }

  Widget emptyTaskList() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 75, bottom: 40),
            child: SizedBox(
              height: 200,
              child: Image.asset('images/kirby-happy-jumping.png'),
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
      ),
    );
  }

  Widget tasks() {
    return Column(
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
                  for (var t in screenModel.taskList)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ToDoItem(
                        task: t,
                        taskIndex: screenModel.taskList.indexOf(t),
                        deleteFn: con.deleteTask,
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _Controller {
  _ToDoScreenState state;
  _Controller(this.state);

  //Used to edit the text on the textformfields
  final datePickedController = TextEditingController();
  final timePickedController = TextEditingController();

  Future<void> save() async {
    FormState? currentSate = state.formKey.currentState;
    if (currentSate == null || !currentSate.validate()) {
      // ignore: avoid_print
      print("======= state not valid...");
      return;
    }
    try {
      // ignore: avoid_print
      print("======== saving...");
      currentSate.save();
      // ignore: avoid_print
      print("======== saved!");
      String docId = await FirestoreController.addKirbyTask(
          kirbyTask: state.screenModel.tempTask);
      state.screenModel.tempTask.taskId = docId;
      getTaskList();
      datePickedController.clear();
      timePickedController.clear();
      if (!state.mounted) return;
      Navigator.pop(state.context);
      showSnackBar(context: state.context, seconds: 3, message: 'Task Added!');
    } catch (e) {
      showSnackBar(
          context: state.context,
          message: "Something went wrong...\nTry again!");
      // ignore: avoid_print
      print("======== upload task error: $e");
    }
  }

  void getTaskList() async {
    state.screenModel.taskList =
        await FirestoreController.getKirbyTaskList(uid: Auth.getUser().uid);
    state.render(() {});
  }

  void deleteTask(String taskId) async {
    await FirestoreController.deleteKirbyTask(taskId: taskId);
    getTaskList();
  }
}
