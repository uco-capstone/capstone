import 'package:achievement_view/achievement_view.dart';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:capstone/controller/auth_controller.dart';
import 'package:capstone/model/home_screen_model.dart';
import 'package:capstone/model/kirby_pet_model.dart';
import 'package:capstone/model/kirby_task_model.dart';
import 'package:capstone/model/kirby_user_model.dart';
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
import '../controller/notifications_controller.dart';
import '../model/constants.dart';
import 'leaderboard_screen.dart';

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
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Allow Notifications'),
              content:
                  const Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
    retrieveScheduledNotifications();
  }

  static Future<void> retrieveScheduledNotifications() async {
    // ignore: unused_local_variable
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    await AwesomeNotifications().cancelAllSchedules();
    // if (scheduledNotifications.isEmpty) {
    // print("creating");
    await createDailyNotification();
    // print("created");
    // }

    // List<NotificationModel> scheduledNotifications =
    //     await awesomeNotifications.listScheduledNotifications();
    // print(scheduledNotifications[0].schedule);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("~My Kirby~"),),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.purple],
              ),
            ),
          ),
          actions: [
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
                //Default Profile Picture
                currentAccountPicture: SizedBox(height: 70, child: Image.asset('images/kirby-ball.png')),
                accountName: screenModel.kirbyUser != null ? Text('${screenModel.kirbyUser!.firstName} ${screenModel.kirbyUser!.lastName}')
                : const Text('No Name'),
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
                leading: const Icon(Icons.groups),
                title: const Text('Leaderboard'),
                onTap: con.leaderboardScreen,
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
      alignment: Alignment.center,
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
          bottom: MediaQuery.of(context).size.height * 0.2,
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
        // Positioned(
        //   //Hunger gauge border
        //   top: 30,
        //   child: Container(
        //     color: Colors.white,
        //     height: 40,
        //     width: 300,
        //   ),
        // ),
        Positioned(
          //Hunger gauge body
          top: MediaQuery.of(context).size.height * 0.05,
          child: _hungerGauge(),
        ),
        // Positioned(
        //   top: 30,
        //   child: SizedBox(
        //     height: 40,
        //     width: 300,
        //     child: Center(
        //         child: Text(
        //             'Hunger Gauge (${screenModel.kirbyPet!.hungerGauge * 10}%)')),
        //   )
        // ),
      ],
    );
  }

  Widget _hungerGauge() {
    return Column(
      children: [
        Stack(
          children: <Widget>[
            Text(
              'Hunger Gauge',
              style: TextStyle(
                fontSize: 15,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.black,
              ),
            ),
            // Solid text as fill.
            const Text(
              'Hunger Gauge',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: const Color.fromARGB(129, 187, 187, 187),
              // color: Color.fromARGB(157, 239, 154, 154),
              border: Border.all(
                color: Colors.black,
                width: 2
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for(int i = 0; i < screenModel.kirbyPet!.hungerGauge; i++)
                    SizedBox(
                      height: 30,
                      child: Image.asset('images/hunger-cake.png')
                    ),
                  if(screenModel.kirbyPet!.hungerGauge != 10)
                    for(int j = 0; j < 10 - screenModel.kirbyPet!.hungerGauge; j++)
                      SizedBox(
                        height: 30,
                        child: Image.asset('images/hunger-cake-empty.png')
                      ),
                ],
              ),
            ),
          ),
        ),
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
    // ignore: use_build_context_synchronously
    showWeekAchievementView(state.context);
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

  /*
  This function loads the KirbyPet that corresponds with the userID.
  If the user doesn't have a KirbyPet, it will create a new one and upload it to the Firebase.
  */
  Future<void> loadKirbyPet() async {
    try {
      //Checks if the user has a pet in the firebase
      bool hasPet = await FirestoreController.hasPet(currentUserID);
      //If there is not a pet, a default pet will be created and uploaded to the firebase
      if (!hasPet) {
        KirbyPet tempPet = KirbyPet(userId: currentUserID);
        state.screenModel.kirbyPet = tempPet;
        await FirestoreController.addPet(kirbyPet: tempPet);
      } else {
        //If there is a pet in the firebase, it will get the pet and store it in the screen model
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

  void leaderboardScreen() {
    Navigator.pushNamed(state.context, LeaderboardScreen.routeName);
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

  /*
  This function goes through the task list, marks task that are past due,
  takes away from the hunger gauge if a task is past due, updates the Firestore,
  and reloads the pet.
  */
  Future<void> checkPastDueTasks() async {
    bool updateFirestore = false;
    var taskList =
        await FirestoreController.getKirbyTaskList(uid: currentUserID);
    var userPet = state.screenModel.kirbyPet;
    // ignore: unused_local_variable
    var kirbyUser = state.screenModel.kirbyUser;
    DateTime currTime = DateTime.now();
    Map<String, dynamic> updatePet = {};
    Map<String, dynamic> updateCurrency = {};

    //Goes through the task list and marks past due tasks
    for (var task in taskList) {
      //If a task is past due, hunger gauge goes down
      if (task.dueDate == null) {
        continue;
      } else if (!task.isPastDue! &&
          !task.isCompleted &&
          task.dueDate!.compareTo(currTime) < 0) {
        if (userPet!.hungerGauge > 0) {
          userPet.hungerGauge--;
          updatePet[DocKeyPet.hungerGauge.name] = userPet.hungerGauge;
        }
        updateFirestore = true;
        Map<String, dynamic> update = {};
        update[DocKeyKirbyTask.isPastDue.name] = true;
        await FirestoreController.updateKirbyTask(
            taskId: task.taskId!, update: update);
      }
    }

    if (userPet!.hungerGauge == 0) {
      updatePet[DocKeyPet.hungerGauge.name] = 10;
      updateCurrency[DocKeyUser.currency.name] = 0;
      showZeroHungerNotification();
      updateFirestore = true;
    }

    if (updateFirestore) {
      await FirestoreController.updateKirbyUser(
          userId: currentUserID, update: updateCurrency);
      await FirestoreController.updatePet(
          userId: currentUserID, update: updatePet);
    }

    //Reload pet
    await loadKirbyPet();
  }

  // checks if all tasks from (the Thursday prior to latest Wednesday) - latest Wednesday were completed (1 week span)
  Future<bool> isWeeklyTasksComplete() async {
    bool isComplete = false;
    DateTime now = DateTime.now();
    int weekday = now.weekday; // monday = 1; sunday = 7

    // get latest wednesday's datetime
    int subtractDays = 0;
    switch (weekday) {
      case 1:
        subtractDays = 5;
        break;
      case 2:
        subtractDays = 6;
        break;
      case 3:
        subtractDays = 0;
        break;
      case 4:
        subtractDays = 1;
        break;
      case 5:
        subtractDays = 2;
        break;
      case 6:
        subtractDays = 3;
        break;
      case 7:
        subtractDays = 4;
        break;
      default:
    }
    DateTime wednesday = now.subtract(Duration(days: subtractDays));

    // bring time to midnight
    DateTime date = DateTime(wednesday.year, wednesday.month, wednesday.day);
    date = date.add(const Duration(days: 1));

    // read from Thursday 12am
    for (int i = 0; i < 7; i++) {
      date = date.subtract(const Duration(days: 1));
      List<KirbyTask> dayTasks =
          await FirestoreController.getDayTasks(uid: currentUserID, day: date);

      // check if all tasks were completed
      if (dayTasks.isEmpty) {
        return false;
      }
      for (var d in dayTasks) {
        if (d.isCompleted == false) {
          isComplete = false;
          return isComplete;
        }
      }
    }

    isComplete = true;
    return isComplete;
  }

  Future<bool> isWeeklyRewardReceived() async {
    // check if reward was recieved for this cycle
    DateTime now = DateTime.now();
    if (state.screenModel.kirbyUser?.weeklyReward == null) {
      return false;
    } else if (state.screenModel.kirbyUser!.weeklyReward!.isBefore(now) &&
        state.screenModel.kirbyUser!.weeklyReward!
            .isAfter(now.subtract(const Duration(days: 7)))) {
      // reward was received during the past week
      return true;
    } else {
      return false;
    }
  }

  // notifies user of weekly reward
  Future<void> showWeekAchievementView(BuildContext context) async {
    // check if weekly reward was already received
    bool weeklyRewardReceived = await isWeeklyRewardReceived();

    if (weeklyRewardReceived) return;

    bool isWeekComplete = await isWeeklyTasksComplete();

    // check if weekly tasks are complete
    if (isWeekComplete) {
      // ignore: use_build_context_synchronously
      AchievementView(context,
              title: "Good Job! 25 Coins",
              subTitle: "You completed all your tasks this week!",
              icon: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset('images/kirby_icon.png'),
              ),
              listener: (status) {})
          .show();

      // reward the 25 coins
      int currency = state.screenModel.kirbyUser!.currency! + 25;
      await FirestoreController.updateKirbyUser(
          userId: currentUserID, update: {'currency': currency});

      // mark reward recevied
      await FirestoreController.updateKirbyUser(
          userId: currentUserID, update: {'weeklyReward': DateTime.now()});
    }
  }
  //Shows Achievment View when hunger Gauge hits zero
  void showZeroHungerNotification() {
    AchievementView(state.context,
            title: "Oh no! Kirby got too hungry!",
            subTitle: "Kirby ate all your coins!",
            icon: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset('images/kirby-dead.png'),
            ),
            listener: (status) {})
        .show();
  }
}
