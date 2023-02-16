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
        actions: [
          IconButton(onPressed: con.toDoListScreen, icon: const Icon(Icons.checklist_rounded)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader( //Default Profile, will add in actual user profile info later
              currentAccountPicture: Icon(Icons.person, size: 70,),
              accountName: Text('No Profile'),
              accountEmail: Text('default@test.com'),
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
    );
  }
}

class _Controller {
  _HomeScreenState state;
  _Controller(this.state);

  void toDoListScreen() {
    //Navigate to the To-Do List Screen
  }

  void signOut() {
    //add sign out functions
  }

  void settingsScreen() {
    //Navigate to the Settings Screen
  }
}