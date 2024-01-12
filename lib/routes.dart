import 'package:e_commerce/screens/end_user/dashboard.dart';
import 'package:e_commerce/screens/end_user/common/signin.dart';
import 'package:e_commerce/screens/end_user/common/signup.dart';

import 'package:flutter/material.dart';

class AppRoutes {
  static const String signIn = '/';
  static const String signUp = '/login';
  static const String dashboard = '/home';


  // Define a method to get all routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      signIn: (context) => const SignInScreen(),
      signUp: (context) => const SignUpScreen(),
      dashboard: (context) => DashboardScreen(),
    };
  }
}