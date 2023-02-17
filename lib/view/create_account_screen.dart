import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:capstone/model/constants.dart';
import 'package:capstone/model/create_account_screen_model.dart';
import 'package:capstone/view/view_util.dart';

import '../controller/auth_controller.dart';

class CreateAccountScreen extends StatefulWidget {
  static const routeName = "/createAccountScreen";

  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateAccountState();
  }
}

class _CreateAccountState extends State<CreateAccountScreen> {
  late _Controller con;
  late CreateAccountScreenModel screenModel;
  final formKey = GlobalKey<FormState>();

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = CreateAccountScreenModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new Account"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  "Create new account",
                  style: Theme.of(context).textTheme.headline5,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter email",
                  ),
                  initialValue: screenModel.email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: screenModel.validateEmail,
                  onSaved: screenModel.saveEmail,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter password",
                  ),
                  initialValue: screenModel.password,
                  obscureText: !screenModel.showPasswords,
                  autocorrect: false,
                  validator: screenModel.validatePassword,
                  onSaved: screenModel.savePassword,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Re-enter password",
                  ),
                  initialValue: screenModel.passwordConf,
                  obscureText: !screenModel.showPasswords,
                  autocorrect: false,
                  validator: screenModel.validatePassword,
                  onSaved: screenModel.savePasswordConf,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: screenModel.showPasswords,
                        onChanged: con.toggleShowPasswords),
                    const Text("Show password"),
                  ],
                ),
                ElevatedButton(
                  onPressed: con.createAccount,
                  child: Text(
                    "Create",
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _CreateAccountState state;
  _Controller(this.state);

  Future<void> createAccount() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    if (state.screenModel.password != state.screenModel.passwordConf) {
      createSnackBar(
        context: state.context,
        message: "Passwords do not match",
        seconds: 5,
      );
      return;
    }

    try {
      await Auth.createAccount(
        email: state.screenModel.email!,
        password: state.screenModel.password!,
      );
      if (state.mounted) {
        Navigator.of(state.context).pop();
      }
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      if (Constant.devMode) print("======= failed to create: $e");
      createSnackBar(
        context: state.context,
        message: "${e.code} ${e.message}",
        seconds: 5,
      );
    } catch (e) {
      // ignore: avoid_print
      if (Constant.devMode) print("======= failed to create: $e");
      createSnackBar(
        context: state.context,
        message: "Failed to create account: $e",
        seconds: 5,
      );
    }
  }

  void toggleShowPasswords(bool? value) {
    if (value != null) {
      state.render(() => state.screenModel.showPasswords = value);
    }
  }
}