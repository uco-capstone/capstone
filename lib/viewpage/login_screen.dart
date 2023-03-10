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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Color.fromARGB(255, 18, 18, 208)],
            ),
          ),
        ),
      ),
      body: screenModel.isSignInUnderway
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : loginForm(),
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
              DecoratedBox(
                decoration: const BoxDecoration(
                  // Image set to background of the body
                  image: DecorationImage(
                      image: AssetImage("images/kirby-login.jpg"),
                      fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Kirbyz Planner",
                        style: Theme.of(context).textTheme.displaySmall),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                // padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter email such as: 1@test.com',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: screenModel.validateEmail,
                  onSaved: screenModel.saveEmail,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                // padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // obscureText: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: "Enter secure password",
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
                          screenModel.passwordVisible = !screenModel
                              .passwordVisible; //change boolean value
                        });
                      },
                    ),
                  ),
                  autocorrect: false,
                  obscureText: !screenModel.passwordVisible,
                  validator: screenModel.validatePassword,
                  onSaved: screenModel.savePassword,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 108, 57, 219),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: con.signin,
                  child: Text("Sign In",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
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
