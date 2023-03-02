import 'package:firebase_auth/firebase_auth.dart';

import 'kirby_user_model.dart';

class TodoScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;
  bool loading = false;

  TodoScreenModel({required this.user});
}
