import 'package:capstone/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/auth_controller.dart';
import '../model/home_scree_model.dart';

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
  late HomeScreenModel screenModel;
  var formKey = GlobalKey<FormState>();
  String title = "Health Form";

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
        title: const Text("Health Information"),
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
                    hintText: "Enter your Age",
                    labelText: "Age",
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.number,
                  validator: KirbyUser.validateAge,
                  // onSaved: con.saveAge,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter your Weight in Pounds",
                    labelText: "Weight (Pounds)",
                  ),
                  autocorrect: true,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter your Height in Inches",
                    labelText: "Height (Inches)",
                  ),
                  autocorrect: true,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter the amount of hours you sleep a night",
                    labelText: "Hours of Sleep",
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter the amount of meals taken a day",
                    labelText: "Meals Taken a Day",
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(onPressed: () => {}, child: const Text("Update"))
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
  // KirbyUser tempUser = KirbyUser(firstName: )

  void saveAge() {}
}
