import 'package:capstone/model/kirby_pet_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'kirby_user_model.dart';

class HomeScreenModel {
  User user;
  String? loadingErrorMessage;
  bool loading = false;
  KirbyUser? kirbyUser;
  KirbyPet? kirbyPet;

  HomeScreenModel({required this.user});
}
