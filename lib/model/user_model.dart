import 'package:capstone/model/height_model.dart';
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
}

class KirbyUser {
  String? userId;
  String firstName;
  String? lastName;
  String? birthday;
  String? weight; // pounds
  Height? height;
  double? averageSleep; // hours
  int? averageMealsEaten;
  KirbyPet? kirbyPet;

  KirbyUser({
    this.userId,
    required this.firstName,
    this.lastName,
    this.birthday,
    this.weight,
    this.height,
    this.averageSleep,
    this.averageMealsEaten,
    this.kirbyPet,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyUser.firstName.name: firstName,
      DocKeyUser.lastName.name: lastName,
      DocKeyUser.birthday.name: birthday,
      DocKeyUser.weight.name: weight,
      DocKeyUser.height.name: height,
      DocKeyUser.averageSleep.name: averageSleep,
      DocKeyUser.averageMealsEaten.name: averageMealsEaten,
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
      kirbyPet: doc[DocKeyUser.kirbyPet.name] ??= "",
    );
  }
}
