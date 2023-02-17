import 'package:flutter/material.dart';

class HealthFormScreen extends StatefulWidget {
  static const routeName = "/healthForm";

  const HealthFormScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HealthFormState();
  }
}

class _HealthFormState extends State<HealthFormScreen> {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
              // children: [],
              ),
        ),
      ),
    );
  }
}
