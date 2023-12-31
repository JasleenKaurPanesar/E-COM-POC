import 'package:e_commerce/reusable_widget/reusable_widget.dart';
import 'package:e_commerce/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce/providers/authProvider.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  late FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  void _signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // If sign in is successful, you can access the user data:
      User? user = userCredential.user;
      print('Signed in: ${user?.uid}');

      AuthenticationProvider authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);

      // Use the login method from AuthProvider
      authProvider.login();

      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      print('Error signing in: $e');

      // Show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign-in failed. Please check your credentials."),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  bool isButtonEnabled() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50),
                alignment: Alignment.center,
                child: Text(
                  'Hello Again!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.questrial(
                    textStyle: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: 180,
                margin: const EdgeInsets.only(top: 5),
                alignment: Alignment.center,
                child: Text(
                  'Welcome back!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.questrial(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ClipRRect(
                child: Image.asset(
                  'assets/images/econmmerce.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.fitWidth,
                ),
              ),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  children: [
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
                    buildTextField(
                      "Confirm Password",
                      Icons.lock_outline,
                      true,
                      _passwordController,
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
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.questrial(
                          textStyle: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => _signInWithEmailAndPassword(context),
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
                      'Sign In',
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'New here?',
                      style: GoogleFonts.questrial(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: 'Create an account',
                      style: GoogleFonts.questrial(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to the sign-up page when "Create an account" is clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                    )
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
