import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void login() {
    // Implement your login logic
    _isAuthenticated = true;
    notifyListeners();
  }


  void logout() {
    // Implement your logout logic
    _isAuthenticated = false;
    notifyListeners();
  }
}
