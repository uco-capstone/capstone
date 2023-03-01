import 'package:firebase_auth/firebase_auth.dart';

import 'kirby_user_model.dart';

class HomeScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;

  HomeScreenModel({required this.user});
}
