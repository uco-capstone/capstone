import 'package:firebase_auth/firebase_auth.dart';

import '../controller/firestore_controller.dart';
import 'kirby_user_model.dart';

class LeaderboardScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;
  bool loading = false;
  late List<dynamic> leaders;

  LeaderboardScreenModel({required this.user});

  // calculate the streak for a user
  Future<void> setLeaders() async {
    leaders = await FirestoreController.getKirbyUserList();
  }
}
