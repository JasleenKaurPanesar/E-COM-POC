import 'package:flutter/material.dart';
import 'package:e_commerce/blocs/auth_bloc/auth_event.dart';
import 'package:e_commerce/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/screens/end_user/common/signin.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
final String title; // Title for the app bar

  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Display user name
      title:Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            // Implement the logout functionality using your userCubit
            context.read<AuthBloc>().add(SignOutEvent());
            Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
          },
        ),
      ],
    );
  }
}
