import 'package:capstone/viewpage/home_screen.dart';
import 'package:capstone/viewpage/view/view_util.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red),
                image: const DecorationImage(
                  image: AssetImage('images/crown.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _AchievementScreenState state;
  _Controller(this.state);
}
