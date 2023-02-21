import 'package:capstone/controller/auth_controller.dart';
import 'package:capstone/model/home_scree_model.dart';
import 'package:capstone/view/health_info_screen.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const UserAccountsDrawerHeader(
              //Default Profile, will add in actual user profile info later
              currentAccountPicture: Icon(
                Icons.person,
                size: 70,
              ),
              accountName: Text('No Profile'),
              accountEmail: Text('default@test.com'),
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Shop'),
              onTap: con.storeScreen,
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: con.settingsScreen,
            ),
            ListTile(
              leading: const Icon(Icons.healing),
              title: const Text('Health Info'),
              onTap: con.healthInfoScreen,
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
            //Pet is currently a sample image, to change pet, change the asset image
            child: SizedBox(
              height: 300,
              child: Image.asset('images/sample-kirby.png'),
            ),
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
    );
  }
}

class _Controller {
  _HomeScreenState state;
  _Controller(this.state);

  void toDoListScreen() {
    //Navigate to the To-Do List Screen
  }

  void storeScreen() {
    //Navigate to Store Screen
  }

  void settingsScreen() {
    //Navigate to the Settings Screen
  }

  void healthInfoScreen() async {
    await Navigator.pushNamed(state.context, HealthInfoScreen.routeName);
  }

  void signOut() {
    Auth.signOut();
  }
}
