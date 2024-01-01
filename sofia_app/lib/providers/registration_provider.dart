import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../database/user/user.dart';

class RegistrationProvider with ChangeNotifier {
  String _email = '';
  String _username = '';
  String _password = '';
  bool isPasswordVisible = false;

  String get emailError => _validateEmail(_email);
  String get usernameError => _validateUsername(_username);
  String get passwordError => _validatePassword(_password);

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void toggleVisiblePassword() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<bool> registerUser() async {
    // Validate user input
    if (emailError.isNotEmpty ||
        usernameError.isNotEmpty ||
        passwordError.isNotEmpty) {
      return false;
    }

    // Create User object
    final user = User(null, _email, _username, _password, false);

    // Get the AppDatabase instance
    // final database =
    //   await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    // Get the UserDao instance
    // final userDao = database.userDao;
    final userDao = await SofiaDatabase.userDao;

    // Insert the user into the database
    await userDao.registerUser(user);

    final allUsers = await userDao.getAllUsers();
    print(allUsers);
    print(allUsers.length);

    // // Close the database
    // await database.close();

    return true;
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!_isValidEmail(value)) {
      return 'Invalid email format';
    }
    return '';
  }

  String _validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username is required';
    }
    return '';
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    return '';
  }

  bool _isValidEmail(String email) {
    const emailRegex = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }
}
