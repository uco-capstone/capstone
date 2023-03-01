import 'package:firebase_auth/firebase_auth.dart';

import 'kirby_user_model.dart';

class HealthInfoScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;

  HealthInfoScreenModel({required this.user});
}
