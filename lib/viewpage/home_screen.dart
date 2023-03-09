import 'package:capstone/controller/auth_controller.dart';
import 'package:capstone/model/home_screen_model.dart';
import 'package:capstone/model/kirby_pet_model.dart';
import 'package:capstone/viewpage/health_info_screen.dart';

import 'package:capstone/viewpage/settings_screen.dart';
import 'package:capstone/viewpage/shop_screen.dart';
import 'package:capstone/viewpage/start_dispatcher.dart';
import 'package:capstone/viewpage/todo_screen.dart';
import 'package:capstone/viewpage/view/view_util.dart';
import 'package:flutter/material.dart';

import '../controller/firestore_controller.dart';
import '../model/constants.dart';
import '../model/kirby_user_model.dart';

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
    con.loadKirbyUser();
    con.loadKirbyPet();
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
        body: Stack(
          children: [
            Container(
              //Background is currently a sample image, to change background, change the asset image
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/sample-background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              //Pet, if there is no configured Kirby Pet, then it'll show a default image
              child: SizedBox(
                  height: 300,
                  child: screenModel.kirbyPet == null
                      ? Image.asset('images/default-kirby.png')
                      : screenModel.kirbyPet!.kirbySkin == ""
                          ? Image.asset('images/default-kirby.png')
                          : Image.asset(screenModel.kirbyPet!.kirbySkin!)),
            ),
            Positioned(
              //Sample Hunger Gauge Area
              top: 30,
              left: 50,
              child: Container(
                color: Colors.white,
                height: 40,
                width: 300,
                child: const Center(child: Text('Hunger Gauge')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _HomeScreenState state;
  _Controller(this.state);

  Future<void> loadKirbyUser() async {
    try {
      bool hasKirbyUser =
          await FirestoreController.hasKirbyUser(Auth.getUser().uid);
      if (hasKirbyUser && state.mounted) {
        Navigator.pushNamed(state.context, HealthInfoScreen.routeName);
      }
      state.screenModel.kirbyUser =
          await FirestoreController.getKirbyUser(userId: Auth.getUser().uid);
      state.render(() {});
    } catch (e) {
      // ignore: avoid_print
      if (Constants.devMode) print(" ==== loading error $e");
      state.render(() => state.screenModel.loadingErrorMessage = "$e");
    }
  }

  Future<void> loadKirbyPet() async {
    try {
      bool hasPet = await FirestoreController.hasPet(Auth.getUser().uid);
      if (hasPet == false) {
        KirbyPet tempPet = KirbyPet(userId: Auth.getUser().uid);
        await FirestoreController.addPet(kirbyPet: tempPet);
      }
      state.screenModel.kirbyPet =
          await FirestoreController.getPet(userId: Auth.getUser().uid);
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
    if (state.screenModel.kirbyUser != null) {
      state.screenModel.kirbyUser!.kirbyPetSkin = customization;
    }
    try {
      Map<String, dynamic> update = {};
      update[DocKeyUser.kirbyPetSkin.name] = customization;
      await FirestoreController.updateKirbyUser(
          userId: state.screenModel.kirbyUser!.userId!, update: update);
    } catch (e) {
      if (Constants.devMode) {
        print('======================= Skin Customization Update Error: $e');
      }
      showSnackBar(context: state.context, message: 'Skin Update Error: $e');
    }

    state.render(() {});
  }
}
