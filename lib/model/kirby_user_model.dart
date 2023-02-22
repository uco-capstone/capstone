// import 'package:capstone/model/height_model.dart';
import 'package:capstone/model/kirby_pet_model.dart';

enum DocKeyUser {
  userId,
  firstName,
  lastName,
  birthday,
  weight,
  height,
  averageSleep,
  averageMealsEaten,
  kirbyPet,
  age,
}

class KirbyUser {
  String? userId;
  String firstName;
  String? lastName;
  String? birthday;
  double? weight; // pounds
  int? height;
  int? averageSleep; // hours
  int? averageMealsEaten;
  int? age;
  KirbyPet? kirbyPet;

  KirbyUser({
    required this.userId,
    required this.firstName,
    this.lastName,
    this.birthday,
    this.weight,
    this.height,
    this.averageSleep,
    this.averageMealsEaten,
    this.age,
    this.kirbyPet,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyUser.userId.name: userId,
      DocKeyUser.firstName.name: firstName,
      DocKeyUser.lastName.name: lastName,
      DocKeyUser.birthday.name: birthday,
      DocKeyUser.weight.name: weight,
      DocKeyUser.height.name: height,
      DocKeyUser.averageSleep.name: averageSleep,
      DocKeyUser.averageMealsEaten.name: averageMealsEaten,
      DocKeyUser.age.name: age,
      DocKeyUser.kirbyPet.name: kirbyPet,
    };
  }

  factory KirbyUser.fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String userId,
  }) {
    return KirbyUser(
      userId: userId,
      firstName: doc[DocKeyUser.firstName.name] ??= "",
      lastName: doc[DocKeyUser.lastName.name] ??= "",
      birthday: doc[DocKeyUser.birthday.name] ??= "",
      weight: doc[DocKeyUser.weight.name] ??= "",
      height: doc[DocKeyUser.height.name] ??= "",
      averageSleep: doc[DocKeyUser.averageSleep.name] ??= "",
      averageMealsEaten: doc[DocKeyUser.averageMealsEaten.name] ??= "",
      age: doc[DocKeyUser.age.name] ??= "",
      // kirbyPet: doc[DocKeyUser.kirbyPet.name] ??= "",
    );
  }

  static String? validateAge(String? value) {
    if (value == null || value == "") return "Age cannot be empty.";
    return (int.parse(value) == 0) ? "Age cannot be zero." : null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value == "") return "Weight cannot be empty.";
    return (double.parse(value) == 0) ? "Weight cannot be zero." : null;
  }

  static String? validateHeight(String? value) {
    if (value == null || value == "") return "Height cannot be empty.";
    return (double.parse(value) == 0) ? "Height cannot be zero." : null;
  }

  static String? validateSleep(String? value) {
    if (value == null || value == "") return "Sleep cannot be empty.";
    return (int.parse(value) == 0) ? "There's only 24 hours sir." : null;
  }

  static String? validateMealsEaten(String? value) {
    return (value == null || value == "") ? "Age cannot be empty." : null;
  }
}
