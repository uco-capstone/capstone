import 'package:capstone/viewpage/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:capstone/model/login_screen_model.dart';
import 'package:capstone/viewpage/create_account_screen.dart';

import '../controller/auth_controller.dart';
import '../model/constants.dart';

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
  late LoginScreenModel screenModel;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = LoginScreenModel();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Log In"),
          automaticallyImplyLeading: false,
        ),
        body: screenModel.isSignInUnderway
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : loginForm(),
      ),
    );
  }

  Widget loginForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Pet To-Do App",
                  style: Theme.of(context).textTheme.displaySmall),
              TextFormField(
                decoration: const InputDecoration(hintText: "Email address"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: screenModel.validateEmail,
                onSaved: screenModel.saveEmail,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      screenModel.passwordVisible
                          ? Icons.visibility
                          : Icons
                              .visibility_off, //change icon based on boolean value
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        screenModel.passwordVisible =
                            !screenModel.passwordVisible; //change boolean value
                      });
                    },
                  ),
                ),
                autocorrect: false,
                obscureText: !screenModel.passwordVisible,
                validator: screenModel.validatePassword,
                onSaved: screenModel.savePassword,
              ),
              ElevatedButton(
                onPressed: con.signin,
                child: Text("Sign In",
                    style: Theme.of(context).textTheme.labelLarge),
              ),
              const SizedBox(
                height: 24,
              ),
              OutlinedButton(
                onPressed: con.createAccount,
                child: Text(
                  "Create a new account",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void passShowButton() {}
}

class _Controller {
  _StartState state;
  _Controller(this.state);

  Future<void> signin() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;
    currentState.save();

    state.render(() => state.screenModel.isSignInUnderway = true);

    try {
      await Auth.signIn(
          email: state.screenModel.email!,
          password: state.screenModel.password!);
    } on FirebaseAuthException catch (e) {
      state.render(() => state.screenModel.isSignInUnderway = false);
      var error = 'Sign in error! Reason: ${e.code} ${e.message ?? ""}';
      if (Constants.devMode) {
        // ignore: avoid_print
        print("============== $error");
      }
      showSnackBar(context: state.context, seconds: 20, message: error);
    } catch (e) {
      state.render(() => state.screenModel.isSignInUnderway = false);
      if (Constants.devMode) {
        // ignore: avoid_print
        print("============== Sign In Error! $e");
      }
      showSnackBar(
          context: state.context, seconds: 20, message: "Sign In Error! $e");
    }
  }

  void createAccount() {
    Navigator.pushNamed(state.context, CreateAccountScreen.routeName);
  }
}
