import 'package:capstone/model/purchased_item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'kirby_pet_model.dart';
import 'kirby_user_model.dart';

class ShopScreenModel {
  User user;
  String? loadingErrorMessage;
  KirbyUser? kirbyUser;
  KirbyPet? kirbyPet;
  var purchasedItemsList = <PurchasedItem>[];
  bool loading = false;

  ShopScreenModel({required this.user});
}