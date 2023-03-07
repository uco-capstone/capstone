import 'package:firebase_auth/firebase_auth.dart';

class ShopScreenModel {
  User user;
  String? loadingErrorMessage;

  ShopScreenModel({required this.user});
}