import 'package:capstone/viewpage/home_screen.dart';
import 'package:flutter/material.dart';

class AchievementScreen extends StatefulWidget {
  static const routeName = '/achievementScreen';

  const AchievementScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AchievementScreenState();
  }
}

class _AchievementScreenState extends State<AchievementScreen> {
  late _Controller con;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievement"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
        ),
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
      body:
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Container(
          //         height: 100.0,
          //         width: 100.0,
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           border: Border.all(color: Colors.red),
          //           image: const DecorationImage(
          //             image: AssetImage('images/crown.png'),
          //           ),
          //         ),
          //       ),
          GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    title: Text('Statistics'),
                  ),
                );
              },
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange[200],
                  //borderRadius: BorderRadius.circular(20.0),
                  image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('images/crown.png'),
                  ),
                ),
                child: const Text(
                  'Complete 1 Task',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.orange[200],
            child: const Text("Complete 5 Task"),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.orange[500],
            child: const Text("Complete 10 Task"),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.orange[500],
            child: const Text("Complete 20 Task"),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.orange[600],
            child: const Text('Drink 4oz of Water'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.orange[600],
            child: const Text('Drank 6oz of Water'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.orange[800],
            child: const Text('Drink 12oz of Water'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.orange[800],
            child: const Text('Drink 32oz of Water'),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _AchievementScreenState state;
  _Controller(this.state);
}
