import 'package:firebase_auth/firebase_auth.dart';

import 'kirby_user_model.dart';

class TodoScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;

  TodoScreenModel({required this.user});
}
