import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../database/app_database.dart';
import '../storage/local_store.dart';

class LoginProvider with ChangeNotifier {
  String username = '';
  String password = '';
  bool rememberMe = false;

  final _rememberMeKey = 'rememberMe';
  final _usernameKey = 'username';
  final _passwordKey = 'password';
  bool isPasswordVisible = false;

  void setUsername(String value) {
    username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void toggleVisiblePassword() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  Future<bool> login() async {
    final userDao = await SofiaDatabase.userDao;
    // Fetch the user from the database based on the username
    final user = await userDao.getUserByUsername(username, password);
    if (user != null) {
      //check rememberMe Flag
      await LocalStore.setValue(key: 'userId', value: user.id.toString());
      if (rememberMe) {
        // Save user credentials in secure storage
        await LocalStore.setValue(key: _rememberMeKey, value: 'true');
        await LocalStore.setValue(key: _usernameKey, value: username);
        await LocalStore.setValue(key: _passwordKey, value: password);
      } else {
        // Clear the user credentials from secure storage
        await LocalStore.delete(key: _rememberMeKey);
        await LocalStore.delete(key: _usernameKey);
        await LocalStore.delete(key: _passwordKey);
      }

      //Provider.of<AuthProvider>(context, listen: false)
      //   .login(username, password);
      print('Success');
      return true;
    } else {
      print('Failed');
      return false;
    }

    // Close the database
    // await database.close();
  }

  void loadRememberMeData() async {
    final rememberMeValue = await LocalStore.getValue(key: _rememberMeKey);
    final storedUsername = await LocalStore.getValue(key: _usernameKey);
    final storedPassword = await LocalStore.getValue(key: _passwordKey);

    if (rememberMeValue == 'true' &&
        storedUsername != null &&
        storedPassword != null) {
      rememberMe = true;
      username = storedUsername;
      password = storedPassword;
    }

    notifyListeners();
  }
}
