import 'package:capstone/model/height_model.dart';

enum DocKeyUser {
  userId,
  firstName,
  lastName,
  birthday,
  weight,
  height,
}

class User {
  String? userId;
  String firstName;
  String? lastName;
  String? birthday;
  String? weight; // pounds
  Height? height;  

  User({
    this.userId,
    required this.firstName,
    this.lastName,
    this.birthday,
    this.weight,
    this.height,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyUser.firstName.name: firstName,
      DocKeyUser.lastName.name: lastName,
      DocKeyUser.birthday.name: birthday,
      DocKeyUser.weight.name: weight,
      DocKeyUser.height.name: height,
    };
  }

  factory User.fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String userId,
  }) {
    return User(
      userId: userId,
      firstName: doc[DocKeyUser.firstName.name] ??= "",
      lastName: doc[DocKeyUser.lastName.name] ??= "",
      birthday: doc[DocKeyUser.birthday.name] ??= "",
      weight: doc[DocKeyUser.weight.name] ??= "",
      height: doc[DocKeyUser.height.name] ??= "",
    );
  }
}
