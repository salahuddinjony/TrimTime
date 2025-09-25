import 'package:get/get_utils/src/get_utils/get_utils.dart';

class Validators {
  //>>>>>>>✅✅ EmailValidator ✅✅ <<<<<<<<=============
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  //>>>>>>>✅✅ PasswordValidator ✅✅ <<<<<<<<=============
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  //>>>>>>>✅✅ Confirm PasswordValidator ✅✅ <<<<<<<<=============
  static String? confirmPasswordValidator(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  //>>>>>>>✅✅ NameValidator ✅✅ <<<<<<<<=============
  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Only alphabetic characters and spaces are allowed';
    }
    return null;
  }

  //>>>>>>>✅✅ PhoneNumberValidator ✅✅ <<<<<<<<=============
  static String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!RegExp(r'^(?:\+88|88)?01[1-9]\d{8}$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

}
