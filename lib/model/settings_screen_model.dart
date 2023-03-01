import 'package:firebase_auth/firebase_auth.dart';

import 'kirby_user_model.dart';

class SettingsScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;
  bool loading = false;

  SettingsScreenModel({required this.user});
}
