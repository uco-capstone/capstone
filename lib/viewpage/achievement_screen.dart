import 'package:capstone/controller/auth_controller.dart';
import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/viewpage/home_screen.dart';
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
        // AppBar: UI customization
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
      // Body: Beginning ListTiles for Cards
      body: con.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Tap-Card: Viewing statistics
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text('You have completed this task'),
                        ),
                      );
                    },
                    // Container: Images for Trophies are stored if user has obtained achievement
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks > 0
                            ? Colors.transparent
                            : Colors.orange[200],
                        //borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(
                                  con.numberOfCompletedTasks > 0 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage('images/crown.png'),
                        ),
                      ),
                      child: const Text(
                        'Complete 1 Task',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Tap-Card: Viewing statistics
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text('You have completed this task'),
                        ),
                      );
                    },
                    // Container: Images for Trophies are stored if user has obtained achievement
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks >= 5
                            ? Colors.transparent
                            : Colors.orange[200],
                        //borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(
                                  con.numberOfCompletedTasks >= 5 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage('images/crown.png'),
                        ),
                      ),
                      child: const Text(
                        'Complete 5 Task',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Tap-Card: Viewing statistics
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text('You have completed this task'),
                        ),
                      );
                    },
                    // Container: Images for Trophies are stored if user has obtained achievement
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks >= 10
                            ? Colors.transparent
                            : Colors.orange[200],
                        //borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(
                                  con.numberOfCompletedTasks >= 10 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage('images/crown.png'),
                        ),
                      ),
                      child: const Text(
                        'Complete 10 Task',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Tap-Card: Viewing statistics
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text('You have completed this task'),
                        ),
                      );
                    },
                    // Container: Images for Trophies are stored if user has obtained achievement
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks >= 15
                            ? Colors.transparent
                            : Colors.orange[200],
                        //borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(
                                  con.numberOfCompletedTasks >= 15 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage('images/crown.png'),
                        ),
                      ),
                      child: const Text(
                        'Complete 15 Task',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Tap-Card: Viewing statistics
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text('You have completed this task'),
                        ),
                      );
                    },
                    // Container: Images for Trophies are stored if user has obtained achievement
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks >= 20
                            ? Colors.transparent
                            : Colors.orange[200],
                        //borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(
                                  con.numberOfCompletedTasks >= 20 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage('images/crown.png'),
                        ),
                      ),
                      child: const Text(
                        'Complete 20 Task',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Tap-Card: Viewing statistics
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text('You have completed this task'),
                        ),
                      );
                    },
                    // Container: Images for Trophies are stored if user has obtained achievement
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks >= 25
                            ? Colors.transparent
                            : Colors.orange[200],
                        //borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(
                                  con.numberOfCompletedTasks >= 25 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage('images/crown.png'),
                        ),
                      ),
                      child: const Text(
                        'Complete 25 Task',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Tap-Card: Viewing statistics
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text('You have completed this task'),
                        ),
                      );
                    },
                    // Container: Images for Trophies are stored if user has obtained achievement
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks >= 30
                            ? Colors.transparent
                            : Colors.orange[200],
                        //borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(
                                  con.numberOfCompletedTasks >= 30 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage('images/crown.png'),
                        ),
                      ),
                      child: const Text(
                        'Complete 30 Task',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    // Tap-Card: Viewing statistics
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text('You have completed this task'),
                        ),
                      );
                    },
                    // Container: Images for Trophies are stored if user has obtained achievement
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: con.numberOfCompletedTasks >= 35
                            ? Colors.transparent
                            : Colors.orange[200],
                        //borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(
                                  con.numberOfCompletedTasks >= 35 ? 1 : 0.2),
                              BlendMode.dstATop),
                          image: const AssetImage('images/crown.png'),
                        ),
                      ),
                      child: const Text(
                        'Complete 35 Task',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
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
