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
import 'package:e_commerce/blocs/shops_bloc/shops_bloc.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_bloc.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<ShopsBloc>(create: (context) => ShopsBloc()),
        BlocProvider<CartBloc>(create: (context) => CartBloc()), // Add ShopsBloc here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => DashboardScreen(),
          '/login': (context) => const SignUpScreen(),
          '/home': (context) => DashboardScreen(),
        },
      ),
    );
  }
}