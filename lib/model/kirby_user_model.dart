enum DocKeyUser {
  userId,
  firstName,
  lastName,
  birthday,
  weight,
  height,
  averageSleep,
  averageMealsEaten,
  age,
  preloadedTasks,
  notifications,
  currency,
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
  bool? preloadedTasks;
  bool? notifications;
  int? currency;

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
    this.preloadedTasks,
    this.notifications,
    this.currency,
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
      DocKeyUser.preloadedTasks.name: preloadedTasks,
      DocKeyUser.notifications.name: notifications,
      DocKeyUser.currency.name: currency,
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
      preloadedTasks: doc[DocKeyUser.preloadedTasks.name] ??= false,
      notifications: doc[DocKeyUser.notifications.name] ??= false,
      currency: doc[DocKeyUser.currency.name] ??= 10,
    );
  }

  static String? validateName(String? value) {
    return (value == null || value == "") ? "Name cannot be empty." : null;
  }

  static String? validateAge(String? value) {
    if (value == null || value == "") return "Age cannot be empty.";
    if (notANumber(value)) return "Must enter numbers only.";
    return (int.parse(value) == 0) ? "Age cannot be zero." : null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value == "") return "Weight cannot be empty.";
    if (notANumber(value)) return "Must enter numbers only.";
    return (double.parse(value) == 0) ? "Weight cannot be zero." : null;
  }

  static String? validateHeight(String? value) {
    if (value == null || value == "") return "Height cannot be empty.";
    if (notANumber(value)) return "Must enter numbers only.";
    return (double.parse(value) == 0) ? "Height cannot be zero." : null;
  }

  static String? validateSleep(String? value) {
    if (value == null || value == "") return "Sleep cannot be empty.";
    if (notANumber(value)) return "Must enter numbers only.";
    return (int.parse(value) == 0 || int.parse(value) >= 24)
        ? "You ok bestie?"
        : null;
  }

  static String? validateMealsEaten(String? value) {
    if (value == null || value == "") return "Age cannot be empty.";
    if (notANumber(value)) return "Must enter numbers only.";
    return null;
  }

  static bool notANumber(String value) {
    return double.tryParse(value) == null;
  }
}
