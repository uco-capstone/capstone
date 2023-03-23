import 'package:firebase_auth/firebase_auth.dart';

import 'kirby_user_model.dart';

class HistoryScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;
  bool loading = false;

  HistoryScreenModel({required this.user});
}
