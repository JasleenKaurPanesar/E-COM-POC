import 'package:flutter/material.dart';
import 'package:e_commerce/blocs/auth_bloc/auth_event.dart';
import 'package:e_commerce/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/screens/signin.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
final String title; // Title for the app bar

  CustomAppBar({required this.title});

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Display user name
      title:Text(title),
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            // Implement the logout functionality using your userCubit
            context.read<AuthBloc>().add(SignOutEvent());
            Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );
          },
        ),
      ],
    );
  }
}
