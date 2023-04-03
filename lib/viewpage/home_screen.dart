import 'package:capstone/controller/auth_controller.dart';
import 'package:capstone/model/home_screen_model.dart';
import 'package:capstone/model/kirby_pet_model.dart';
import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/viewpage/achievement_screen.dart';
import 'package:capstone/viewpage/health_info_screen.dart';
import 'package:capstone/viewpage/history_screen.dart';
import 'dart:async';

import 'package:capstone/viewpage/settings_screen.dart';
import 'package:capstone/viewpage/shop_screen.dart';
import 'package:capstone/viewpage/start_dispatcher.dart';
import 'package:capstone/viewpage/todo_screen.dart';
import 'package:capstone/viewpage/view/view_util.dart';
import 'package:flutter/material.dart';

import '../controller/firestore_controller.dart';
import '../model/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/homeScreen';

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late _Controller con;
  late HomeScreenModel screenModel;

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = HomeScreenModel(user: Auth.user!);
    con.initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kirby!'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 75,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    //Sample number of coins
                    Text(
                      '0',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.monetization_on,
                      color: Colors.orangeAccent,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: con.toDoListScreen,
              icon: const Icon(Icons.checklist_rounded),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                //Default Profile, will add in actual user profile info later
                currentAccountPicture: const Icon(
                  Icons.person,
                  size: 70,
                ),
                accountName: const Text("Some Dude"),
                accountEmail: Text("${screenModel.user.email}"),
              ),
              ListTile(
                leading: const Icon(Icons.store),
                title: const Text('Shop'),
                onTap: con.shopScreen,
              ),
              ListTile(
                leading: const Icon(Icons.assessment_outlined),
                title: const Text('History'),
                onTap: con.historyScreen,
              ),
              ListTile(
                leading: const Icon(Icons.stars),
                title: const Text('Achievements'),
                onTap: con.achievementScreen,
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: con.settingsScreen,
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: con.signOut,
              ),
            ],
          ),
        ),
        body: screenModel.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : body(),
      ),
    );
  }

  Widget body() {
    return Stack(
      children: [
        Container(
          //Background, if there is no configured background, then it'll show a default image
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: screenModel.kirbyPet == null
                    ? const AssetImage(
                        'images/backgrounds/default-background.png')
                    : screenModel.kirbyPet!.background == "" ||
                            screenModel.kirbyPet!.background == null
                        ? const AssetImage(
                            'images/backgrounds/default-background.png')
                        : AssetImage(screenModel.kirbyPet!.background!)),
          ),
        ),
        Positioned(
          top: 210,
          left: 55,
          //Pet, if there is no configured Kirby Pet, then it'll show a default image
          child: SizedBox(
              height: 300,
              child: screenModel.kirbyPet == null
                  ? Image.asset('images/skins/default-kirby.png')
                  : screenModel.kirbyPet!.kirbySkin == "" ||
                          screenModel.kirbyPet!.kirbySkin == null
                      ? Image.asset('images/skins/default-kirby.png')
                      : Image.asset(screenModel.kirbyPet!.kirbySkin!)),
        ),
        Positioned(
          //Hunger gauge border
          top: 30,
          left: 50,
          child: Container(
            color: Colors.white,
            height: 40,
            width: 300,
          ),
        ),
        Positioned(
          //Hunger gauge body
          top: 32,
          left: 52,
          child: Container(
            //Change color and size based off of percentage
            color: screenModel.kirbyPet!.hungerGauge > 7
                ? Colors.green
                : screenModel.kirbyPet!.hungerGauge > 3
                    ? Colors.yellow
                    : Colors.red,
            height: 36,
            width: (296 * screenModel.kirbyPet!.hungerGauge * .1),
          ),
        ),
        Positioned(
            top: 30,
            left: 50,
            child: SizedBox(
              height: 40,
              width: 300,
              child: Center(
                  child: Text(
                      'Hunger Gauge (${screenModel.kirbyPet!.hungerGauge * 10}%)')),
            )),
      ],
    );
  }
}

class _Controller {
  _HomeScreenState state;
  _Controller(this.state);
  late String currentUserID;
  Timer? timer;

  void initScreen() async {
    state.screenModel.loading = true;
    getUID();
    await loadKirbyUser();
    await loadKirbyPet();
    await getTimer();
    state.screenModel.loading = false;
  }

  //Creates a Timer for 10 seconds
  Future<void> getTimer() async {
    timer = Timer.periodic(
        const Duration(seconds: 10), (Timer t) => checkPastDueTasks());
  }

  void getUID() {
    currentUserID = state.screenModel.user.uid;
  }

  Future<void> loadKirbyUser() async {
    try {
      bool hasKirbyUser = await FirestoreController.hasKirbyUser(currentUserID);
      if (!hasKirbyUser && state.mounted) {
        Navigator.pushNamed(state.context, HealthInfoScreen.routeName);
      }
      state.screenModel.kirbyUser =
          await FirestoreController.getKirbyUser(userId: currentUserID);
      state.render(() {});
    } catch (e) {
      // ignore: avoid_print
      if (Constants.devMode) print(" ==== loading error $e");
      state.render(() => state.screenModel.loadingErrorMessage = "$e");
    }
  }

  Future<void> loadKirbyPet() async {
    try {
      bool hasPet = await FirestoreController.hasPet(currentUserID);
      if (!hasPet) {
        KirbyPet tempPet = KirbyPet(userId: currentUserID);
        state.screenModel.kirbyPet = tempPet;
        await FirestoreController.addPet(kirbyPet: tempPet);
      } else {
        state.screenModel.kirbyPet =
            await FirestoreController.getPet(userId: currentUserID);
      }
      state.render(() {});
    } catch (e) {
      // ignore: avoid_print
      if (Constants.devMode) print(" ==== loading error $e");
      state.render(() => state.screenModel.loadingErrorMessage = "$e");
    }
  }

  void toDoListScreen() {
    Navigator.pushNamed(state.context, ToDoScreen.routeName);
  }

  void shopScreen() {
    Navigator.pushNamed(state.context, ShopScreen.routeName)
        .then((value) => state.render(() {}));
  }

  void historyScreen() async {
    await Navigator.pushNamed(state.context, HistoryScreen.routeName);
  }

  void achievementScreen() {
    Navigator.pushNamed(state.context, AchievementScreen.routeName)
        .then((value) => state.render(() {}));
  }

  void settingsScreen() async {
    await Navigator.pushNamed(state.context, SettingsScreen.routeName);
  }

  Future<void> signOut() async {
    try {
      await Auth.signOut();
    } catch (e) {
      // ignore: avoid_print
      if (Constants.devMode) print('****************** Sign Out Error: $e');
      showSnackBar(
          context: state.context, seconds: 20, message: 'Sign Out Error: $e');
    }
    if (!state.mounted) return;
    Navigator.pushNamed(state.context, StartDispatcher.routeName);
  }

  void updateSkinCustomization(String customization) async {
    if (state.screenModel.kirbyPet != null) {
      state.screenModel.kirbyPet!.kirbySkin = customization;
    }
    try {
      Map<String, dynamic> update = {};
      update[DocKeyPet.kirbySkin.name] = customization;
      await FirestoreController.updateKirbyUser(
          userId: state.screenModel.kirbyUser!.userId!, update: update);
    } catch (e) {
      if (Constants.devMode) {
        // ignore: avoid_print
        print('======================= Skin Customization Update Error: $e');
      }
      showSnackBar(context: state.context, message: 'Skin Update Error: $e');
    }

    state.render(() {});
  }

  /*
  This function goes through the task list, marks task that are past due,
  takes away from the hunger gauge if a task is past due, updates the Firestore,
  and reloads the pet.
  */
  Future<void> checkPastDueTasks() async {
    var taskList =
        await FirestoreController.getKirbyTaskList(uid: currentUserID);
    var userPet = state.screenModel.kirbyPet;
    DateTime currTime = DateTime.now();
    //Goes through the task list and marks past due tasks
    for (var task in taskList) {
      //If a task is past due, hunger gauge goes down
      if (task.dueDate == null) {
        continue;
      } else if (!task.isPastDue! && task.dueDate!.compareTo(currTime) < 0) {
        Map<String, dynamic> updateTask = {};
        updateTask[DocKeyKirbyTask.isPastDue.name] = true;
        Map<String, dynamic> updatePet = {};
        if (userPet!.hungerGauge > 0) {
          updatePet[DocKeyPet.hungerGauge.name] = userPet.hungerGauge - 1;
        }
        //update Firestore
        await FirestoreController.updateKirbyTask(
            taskId: task.taskId!, update: updateTask);
        await FirestoreController.updatePet(
            userId: currentUserID, update: updatePet);
      }
    }
    //Reload pet
    await loadKirbyPet();
  }
}
