import 'package:e_commerce/reusable_widget/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screens/dashboard.dart';
import 'package:e_commerce/providers/authProvider.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String _selectedRole = 'End User';
  final _formKey = GlobalKey<FormState>();

  bool isButtonEnabled() {
    return _formKey.currentState?.validate() ?? false;
  }

  void movetoHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Add user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(result.user!.uid)
            .set({
          'username': _userNameController.text,
          'email': _emailController.text,
          'role': _selectedRole,
        });

        if (result.user != null) {
          AuthenticationProvider authProvider =
              Provider.of<AuthenticationProvider>(context, listen: false);

          // Use the login method from AuthProvider
          authProvider.login();
            Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
          (route) => false,
        );
        }
      } catch (e) {
        print(e);
        // Handle the error, show a message to the user, etc.
      }
      setState(() {});

       Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ... (Your existing UI code)
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child:ClipRRect(
                    child: Image.asset(
                      'assets/images/econmmerce.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.fitWidth,
                    ),
                  )),
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 10),
                    alignment: Alignment.center,
                    child: Text(
                      'Please enter the details below to continue',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.questrial(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  buildTextField(
                    "Enter Username",
                    Icons.person_2_outlined,
                    false,
                    _userNameController,
                    (value) =>
                        value!.isEmpty ? 'Username cannot be empty' : null,
                    isButtonEnabled(),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: ['End User', 'Shop Owner'].map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedRole = value;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Role',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200], // Background color
                    ),
                    style: GoogleFonts.questrial(
                      textStyle: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email TextField
                  buildTextField(
                    "Enter Email",
                    Icons.mail_outline,
                    false,
                    _emailController,
                    (value) =>
                        value!.isEmpty ? 'Email Id cannot be empty' : null,
                    isButtonEnabled(),
                  ),
                  const SizedBox(height: 20),
                  // Password TextField
                  buildTextField(
                    "Enter Password",
                    Icons.lock_outline,
                    true,
                    _passwordController,
                    (value) {
                      if (value!.isEmpty) {
                        return 'Password cannot be empty';
                      } else if (value.length < 6) {
                        return 'Password length should be at least 6';
                      } else {
                        return null;
                      }
                    },
                    isButtonEnabled(),
                  ),
                  const SizedBox(height: 20),
                  // Confirm Password TextField
                  buildTextField(
                    "Confirm Password",
                    Icons.lock_outline,
                    true,
                    _confirmPasswordController,
                    (value) {
                      if (value!.isEmpty) {
                        return 'Confirm Password cannot be empty';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      } else {
                        return null;
                      }
                    },
                    isButtonEnabled(),
                  ),
                  const SizedBox(height: 20),
                  // Sign In Button
                  InkWell(
                    onTap: () => movetoHome(context),
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: 350,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 226, 73, 73),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.questrial(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
