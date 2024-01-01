import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _loggedInUsername;

  bool get isLoggedIn => _isLoggedIn;
  String? get loggedInUsername => _loggedInUsername;

  // Simulating the login process
  Future<void> login(String username, String password) async {
    // Perform the login process here (e.g., validate credentials, authenticate with backend, etc.)
    // For simplicity, let's assume the login is successful

    // Update the authentication state
    _isLoggedIn = true;
    _loggedInUsername = username;
    print("=====LoggedinUsername============$_loggedInUsername");

    notifyListeners();
  }

  // Simulating the logout process
  void logout() {
    // Update the authentication state
    _isLoggedIn = false;
    _loggedInUsername = null;

    notifyListeners();
  }
}
