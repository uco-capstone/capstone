import 'package:firebase_auth/firebase_auth.dart';

class HomeScreenModel {
  User user;
  String? loadingErrorMessage;

  HomeScreenModel({required this.user});
}