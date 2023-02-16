import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/loginScreen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StartState();
  }
}

class _StartState extends State<LoginScreen> {
  late _Controller con;
  final formKey = GlobalKey<FormState>();

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
        title: const Text("Sign In"),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Pet To-Do App",
                  style: Theme.of(context).textTheme.headline3),
              TextFormField(
                decoration: const InputDecoration(hintText: "Email address"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: con.validateEmail,
                onSaved: con.saveEmail,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Password"),
                autocorrect: false,
                obscureText: true,
                validator: con.validatePassword,
                onSaved: con.savePassword,
              ),
              ElevatedButton(
                onPressed: con.signin,
                child:
                    Text("Sign In", style: Theme.of(context).textTheme.button),
              ),
              const SizedBox(
                height: 24,
              ),
              OutlinedButton(
                onPressed: con.signUp,
                child: Text(
                  "Create a new account",
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _StartState state;
  String? email;
  String? password;

  _Controller(this.state);

  void signUp() {
    // Navigator.pushNamed(state.context, SignUpScreen.routeName);
  }

  Future<void> signin() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;
    currentState.save();

    // startCircularProgress(state.context);

    // User? user;
    try {
      if (email == null || password == null) {
        throw "Email or Password is null";
      }
      // user = await AuthController.signIn(email: email!, password: password!);

      // stopCircularProgress(state.context);

      // Navigator.pushNamed(
      //   state.context,
      //   HomeScreen.routeName,
      //   arguments: {
      //     ArgKey.user: user,
      //   },
      // );
    } catch (e) {
      // stopCircularProgress(state.context);
      // if (Constant.devMode) print("********* Sign In Error: $e");
      // showSnackBar(
      //     context: state.context, seconds: 20, message: "Sign In Error: $e");
    }
  }

  String? validateEmail(String? value) {
    if (value == null) {
      return "No email provided";
    } else if (!(value.contains('@') && value.contains('.'))) {
      return "Invalid email format";
    } else {
      return null;
    }
  }

  void saveEmail(String? value) {
    if (value != null) {
      email = value;
    }
  }

  String? validatePassword(String? value) {
    if (value == null) {
      return "password not provided";
    } else if (value.length < 6) {
      return "password too short";
    } else {
      return null;
    }
  }

  void savePassword(String? value) {
    if (value != null) {
      password = value;
    }
  }
}
