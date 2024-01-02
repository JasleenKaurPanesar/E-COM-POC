import 'package:e_commerce/screens/dashboard.dart';
import 'package:e_commerce/screens/signin.dart';
import 'package:e_commerce/screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/providers/cartProvider.dart';
import 'package:e_commerce/providers/shopsProvider.dart';
import 'package:e_commerce/providers/authProvider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/blocs/auth_bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SignInScreen(),
          '/login': (context) => const SignUpScreen(),
          '/home': (context) => DashboardScreen(),
        },
      ),
    );
  }
}