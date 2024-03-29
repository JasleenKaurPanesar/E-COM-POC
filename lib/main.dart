import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/blocs/auth_bloc/auth_bloc.dart';
import 'package:e_commerce/blocs/shops_bloc/shops_bloc.dart';
import 'package:e_commerce/blocs/cart_bloc/cart_bloc.dart';
import 'package:e_commerce/cubit/user_cubit.dart';
import 'package:e_commerce/cubit/role_cubit.dart';
import 'package:e_commerce/routes.dart';
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
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => RoleCubit()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<ShopsBloc>(create: (context) => ShopsBloc()),
        // Provide ShopsBloc to CartBloc
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(
            shopsBloc: context.read<ShopsBloc>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
