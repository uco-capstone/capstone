class LoginScreenModel {
  String? email;
  String? password;
  bool isSignInUnderway = false;

  String? validateEmail(String? value) {
    if (value == null) {
      return "No email provided";
    } else if (!(value.contains('@') && value.contains('.'))) {
      return "Invalid email";
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value == null) {
      return "No password provided";
    } else if (value.length < 6) {
      return "Password too short";
    } else {
      return null;
    }
  }

  void saveEmail(String? value) {
    if (value != null) {
      email = value;
    }
  }

  void savePassword(String? value) {
    if (value != null) {
      password = value;
    }
  }
}