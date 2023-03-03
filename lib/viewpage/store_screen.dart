import 'package:flutter/material.dart';

class StoreScreen extends StatefulWidget {
  static const routeName = '/storeScreen';

  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StoreScreen();
  }
}

class _StoreScreen extends State<StoreScreen> {
  late _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      //body: const Text('Start Screen works!'),
      body: const Text('Store Screen'),
    );
  }
}

class _Controller {
  _StoreScreen state;
  _Controller(this.state);
}
