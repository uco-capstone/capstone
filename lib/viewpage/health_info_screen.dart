import 'package:capstone/controller/firestore_controller.dart';
import 'package:capstone/model/health_info_screen_model.dart';
import 'package:capstone/model/kirby_user_model.dart';
import 'package:capstone/viewpage/start_dispatcher.dart';
import 'package:capstone/viewpage/view/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/auth_controller.dart';

class HealthInfoScreen extends StatefulWidget {
  static const routeName = "/healthInfo";

  const HealthInfoScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HealthInfoState();
  }
}

class _HealthInfoState extends State<HealthInfoScreen> {
  late _Controller con;
  late HealthInfoScreenModel screenModel;
  var formKey = GlobalKey<FormState>();
  String title = "Health Form";
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController sleepController = TextEditingController();
  final TextEditingController mealsController = TextEditingController();

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = HealthInfoScreenModel(user: Auth.user!);
    con.findKirbyUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Health Information"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter your First Name",
                    labelText: "First Name",
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  validator: KirbyUser.validateFirstName,
                  onSaved: con.saveFirstName,
                  controller: firstNameController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter your Last Name",
                    labelText: "Last Name",
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.name,
                  validator: KirbyUser.validateLastName,
                  onSaved: con.saveLastName,
                  controller: lastNameController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter your Age",
                    labelText: "Age",
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.number,
                  validator: KirbyUser.validateAge,
                  onSaved: con.saveAge,
                  controller: ageController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter your Weight in pounds",
                    labelText: "Weight (lbs)",
                  ),
                  autocorrect: true,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  validator: KirbyUser.validateWeight,
                  onSaved: con.saveWeight,
                  controller: weightController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter your Height in cm",
                    labelText: "Height (cm)",
                  ),
                  autocorrect: true,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  validator: KirbyUser.validateHeight,
                  onSaved: con.saveHeight,
                  controller: heightController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText:
                        "Enter the average amount of hours you sleep a night",
                    labelText: "Average Hours of Sleep a Night",
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.number,
                  validator: KirbyUser.validateSleep,
                  onSaved: con.saveSleep,
                  controller: sleepController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText:
                        "Enter the average amount of meals you eat in a day",
                    labelText: "Average Meals Eaten a Day",
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.number,
                  validator: KirbyUser.validateMealsEaten,
                  onSaved: con.saveMeals,
                  controller: mealsController,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: con.save,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue)),
                    child: const Text("Save"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _HealthInfoState state;
  _Controller(this.state);
  KirbyUser tempKirbyUser = KirbyUser(
      userId: Auth.getUser().uid,
      firstName: Auth.getUser().displayName == null
          ? ""
          : Auth.getUser().displayName!);

  Future<void> findKirbyUser() async {
    KirbyUser pulledUser =
        await FirestoreController.getKirbyUser(userId: Auth.getUser().uid);
    tempKirbyUser = pulledUser;
    state.firstNameController.text =
        state.con.tempKirbyUser.firstName.toString() == "null"
            ? ""
            : state.con.tempKirbyUser.firstName.toString();
    state.lastNameController.text =
        state.con.tempKirbyUser.lastName.toString() == "null"
            ? ""
            : state.con.tempKirbyUser.lastName.toString();
    state.ageController.text = state.con.tempKirbyUser.age.toString() == "null"
        ? ""
        : state.con.tempKirbyUser.age.toString();
    state.weightController.text =
        state.con.tempKirbyUser.weight.toString() == "null"
            ? ""
            : state.con.tempKirbyUser.weight.toString();
    state.heightController.text =
        state.con.tempKirbyUser.height.toString() == "null"
            ? ""
            : state.con.tempKirbyUser.height.toString();
    state.sleepController.text =
        state.con.tempKirbyUser.averageSleep.toString() == "null"
            ? ""
            : state.con.tempKirbyUser.averageSleep.toString();
    state.mealsController.text =
        state.con.tempKirbyUser.averageMealsEaten.toString() == "null"
            ? ""
            : state.con.tempKirbyUser.averageMealsEaten.toString();
  }

  void save() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) {
      return;
    }
    currentState.save();

    try {
      await FirestoreController.addHealthInfo(kirbyUser: tempKirbyUser);
      // ignore: use_build_context_synchronously
      showSnackBar(context: state.context, message: 'Success!');
      if (state.mounted) {
        Navigator.pushNamed(state.context, StartDispatcher.routeName);
      }
    } catch (e) {
      showSnackBar(context: state.context, message: "Error: $e");
    }
  }

  void saveFirstName(String? value) {
    if (value != null) {
      tempKirbyUser.firstName = value;
    }
  }

  void saveLastName(String? value) {
    if (value != null) {
      tempKirbyUser.lastName = value;
    }
  }

  void saveAge(String? value) {
    if (value != null) {
      tempKirbyUser.age = int.parse(value);
    }
  }

  void saveWeight(String? value) {
    if (value != null) {
      tempKirbyUser.weight = double.parse(value);
    }
  }

  void saveHeight(String? value) {
    if (value != null) {
      tempKirbyUser.height = int.parse(value);
    }
  }

  void saveSleep(String? value) {
    if (value != null) {
      tempKirbyUser.averageSleep = int.parse(value);
    }
  }

  void saveMeals(String? value) {
    if (value != null) {
      tempKirbyUser.averageMealsEaten = int.parse(value);
    }
  }
}
