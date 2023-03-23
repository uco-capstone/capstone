import 'package:firebase_auth/firebase_auth.dart';

import 'kirby_pet_model.dart';
import 'kirby_user_model.dart';

class ShopScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;
  KirbyPet? kirbyPet;
  bool loading = false;

  ShopScreenModel({required this.user});
}