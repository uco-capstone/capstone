import 'package:capstone/controller/auth_controller.dart';
import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/viewpage/home_screen.dart';
import 'package:capstone/viewpage/view/kirby_loading.dart';
import 'package:flutter/material.dart';

class AchievementScreen extends StatefulWidget {
  // Route Routing
  static const routeName = '/achievementScreen';

  // Creating key: Super key indicating to the parent class
  const AchievementScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AchievementScreenState();
  }
}

class _AchievementScreenState extends State<AchievementScreen> {
  late _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    con.checkUserCompletedTasks();
  }

  void render(fn) => setState(fn);

  // Checks the taskCompleted flag, and if it's true, it performs the onTap() action
  bool taskCompleted = false;

  // Perform the onTap() action here
  void _onTap() {
    if (taskCompleted) {
      // Perform the onTap() action here
      print(
          '\nYou have already completed this task\nClear the Firestore if you want to reset task');
    } else {
      _showAlertDialog();
    }
  }
  //   if (checkUserCompletedTasks()) {
  //     // Perform the onTap() action here
  //     print('onTap() enabled');
  //   } else {
  //     // Show a message indicating that tasks are not completed
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Alert'),
  //           content: Text('Please complete all tasks.'),
  //           actions: [
  //             TextButton(
  //               child: Text('OK'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congraulations!'),
          content: const Text(
              'Task Completed!! \nYou have completed this task!\nDo you want to enable onTap()?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Enable!'),
              onPressed: () {
                setState(() {
                  taskCompleted = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievements"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
        // AppBar: Gradient customization
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
            ),
          ),
        ),
      ),
      // Body: Beginning ListTiles for Card Containers
      body: con.loading
          ? const Center(
              child: KirbyLoading(),
            )
          : GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                // Trophy #1
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Enable onTap() based on task completion #1
                    onTap: con.numberOfCompletedTasks > 0 ? _onTap : null,
                    // Container for Card 1
                    child: Container(
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks > 0
                            ? Colors.transparent
                            : Colors.orange[200],
                        image: DecorationImage(
                          scale: 1.8,
                          colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(
                                  con.numberOfCompletedTasks > 0 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage(
                            'images/trophies/trophy-9.webp',
                          ),
                        ),
                      ),
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Complete 1 Task',
                        style: TextStyle(fontSize: 17, color: Colors.orange),
                      ),
                    ),
                  ),
                ),
                // Trophy #2
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Enable onTap() based on task completion #2
                    onTap: con.numberOfCompletedTasks > 2 ? _onTap : null,
                    // Container for Card 2
                    child: Container(
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks > 2
                            ? Colors.transparent
                            : Colors.orange[200],
                        image: DecorationImage(
                          scale: 2.1,
                          colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(
                                  con.numberOfCompletedTasks > 2 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage(
                            'images/trophies/trophy-5.webp',
                          ),
                        ),
                      ),
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Complete 3 Task',
                        style: TextStyle(fontSize: 17, color: Colors.orange),
                      ),
                    ),
                  ),
                ),
                // Trophy #3
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Enable onTap() based on task completion #3
                    onTap: con.numberOfCompletedTasks > 4 ? _onTap : null,
                    // Container for Card 3
                    child: Container(
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks > 4
                            ? Colors.transparent
                            : Colors.orange[200],
                        image: DecorationImage(
                          scale: 2.1,
                          colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(
                                  con.numberOfCompletedTasks > 4 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage(
                            'images/trophies/trophy-6.webp',
                          ),
                        ),
                      ),
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Complete 5 Task',
                        style: TextStyle(fontSize: 17, color: Colors.orange),
                      ),
                    ),
                  ),
                ),
                // Trophy #4
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Enable onTap() based on task completion #7
                    onTap: con.numberOfCompletedTasks > 6 ? _onTap : null,
                    // Container for Card 4
                    child: Container(
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks > 6
                            ? Colors.transparent
                            : Colors.orange[200],
                        image: DecorationImage(
                          scale: 2.1,
                          colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(
                                  con.numberOfCompletedTasks > 6 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage(
                            'images/trophies/trophy-4.webp',
                          ),
                        ),
                      ),
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Complete 7 Task',
                        style: TextStyle(fontSize: 17, color: Colors.orange),
                      ),
                    ),
                  ),
                ),
                // Trophy #5
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Enable onTap() based on task completion #10
                    onTap: con.numberOfCompletedTasks > 9 ? _onTap : null,
                    // Container for Card 5
                    child: Container(
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks > 9
                            ? Colors.transparent
                            : Colors.orange[200],
                        image: DecorationImage(
                          scale: 1.5,
                          colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(
                                  con.numberOfCompletedTasks > 9 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage(
                            'images/trophies/trophy-2.png',
                          ),
                        ),
                      ),
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Complete 10 Task',
                        style: TextStyle(fontSize: 17, color: Colors.orange),
                      ),
                    ),
                  ),
                ),
                // Trophy #6
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Enable onTap() based on task completion #15
                    onTap: con.numberOfCompletedTasks > 14 ? _onTap : null,
                    // Container for Card 6
                    child: Container(
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks > 14
                            ? Colors.transparent
                            : Colors.orange[200],
                        image: DecorationImage(
                          scale: 2.2,
                          colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(
                                  con.numberOfCompletedTasks > 14 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage(
                            'images/trophies/trophy-3.webp',
                          ),
                        ),
                      ),
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Complete 15 Task',
                        style: TextStyle(fontSize: 17, color: Colors.orange),
                      ),
                    ),
                  ),
                ),
                // Trophy #7
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Enable onTap() based on task completion #15
                    onTap: con.numberOfCompletedTasks > 19 ? _onTap : null,
                    // Container for Card 7
                    child: Container(
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks > 19
                            ? Colors.transparent
                            : Colors.orange[200],
                        image: DecorationImage(
                          scale: 2.2,
                          colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(
                                  con.numberOfCompletedTasks > 19 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage(
                            'images/trophies/trophy-1.webp',
                          ),
                        ),
                      ),
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Complete 20 Task',
                        style: TextStyle(fontSize: 17, color: Colors.orange),
                      ),
                    ),
                  ),
                ),
                // Trophy #8
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Enable onTap() based on task completion #30
                    onTap: con.numberOfCompletedTasks > 29 ? _onTap : null,
                    // Container for Card 5
                    child: Container(
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks > 29
                            ? Colors.transparent
                            : Colors.orange[200],
                        image: DecorationImage(
                          scale: 1.0,
                          colorFilter: ColorFilter.mode(
                              Colors.white.withOpacity(
                                  con.numberOfCompletedTasks > 29 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage(
                            'images/trophies/trophy-8.webp',
                          ),
                        ),
                      ),
                      child: const Text(
                        textAlign: TextAlign.center,
                        'Complete 30 Task',
                        style: TextStyle(fontSize: 17, color: Colors.orange),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _Controller {
  _AchievementScreenState state;
  _Controller(this.state);

  int numberOfCompletedTasks = 0;
  bool loading = false;

  // // Checks the taskCompleted flag, and if it's true, it performs the onTap() action
  // bool taskCompleted = false;

  Future<void> checkUserCompletedTasks() async {
    loading = true;
    var completedTaskList =
        await FirestoreController.getCompletedTasks(uid: Auth.getUser().uid);

    numberOfCompletedTasks = completedTaskList.length;

    // ignore: avoid_print
    print(completedTaskList.length); // # of completed task a user has obtained
    state.render(() {
      loading = false;
    });
  }
}
