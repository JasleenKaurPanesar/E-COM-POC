import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/providers/authProvider.dart'; // Import your auth provider

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onLogout;

  const CustomAppBar({Key? key, required this.title, required this.onLogout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
   AuthenticationProvider authProvider = Provider.of<AuthenticationProvider>(context);

    return AppBar(
      title: Text(title),
      actions: [
        if (authProvider.isAuthenticated) // Show only if the user is authenticated
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: onLogout,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
