import 'package:e_commerce/helpers/widget_helper.dart';
import 'package:e_commerce/screens/end_user/dashboard.dart';
import 'package:e_commerce/screens/end_user/common/signup.dart';
import 'package:e_commerce/screens/shop_owner/create_shop_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/blocs/auth_bloc/auth_bloc.dart';
import 'package:e_commerce/blocs/auth_bloc/auth_event.dart';
import 'package:e_commerce/blocs/auth_bloc/auth_state.dart';
import 'package:e_commerce/cubit/user_cubit.dart';
import 'package:e_commerce/cubit/role_cubit.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isButtonClicked = false; // Initialize isButtonClicked to false

  @override
  void initState() {
    super.initState();
  }

  void _signInWithEmailAndPassword(BuildContext context) async {
    try {
      
      // Dispatch the sign-in event
      context.read<AuthBloc>().add(
            SignInEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
              

    } catch (e) {
      print("Error during sign-in: $e");

      // Show an error snackbar 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error during sign-in. Please try again."),
          duration: Duration(seconds: 3),
        ),
      );

  
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthAuthenticated) {
            // Handle authentication success
          

            DocumentSnapshot userSnapshot =
                await FirebaseFirestore.instance.collection('users').doc(state.user.uid).get();

            Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

            String userRole = userData['role'];
            
            String uid = state.user.uid;

            context.read<RoleCubit>().setUserRole(userRole);
            context.read<UserCubit>().setUid(uid);

            if (userRole == "Shop Owner") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateShopSuccessScreen(uid: state.user.uid),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(),
                ),
              );
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                duration: const Duration(seconds: 3),
              ),
            );

            // Set isButtonClicked to true on error
            setState(() {
              isButtonClicked = true;
            });
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Column(
                        children: [
                          buildTextField(
                            text: "Enter Email",
                            icon: Icons.mail_outline,
                            controller: _emailController,
                            validator: (value) =>
                                isButtonClicked && value!.isEmpty ? 'Email Id cannot be empty' : null,
                          ),
                          const SizedBox(height: 20),
                          buildTextField(
                            text: "Confirm Password",
                            icon: Icons.lock_outline,
                            isPasswordType: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (isButtonClicked && value!.isEmpty) {
                                return 'Confirm Password cannot be empty';
                              } else if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              } else {
                                return null;
                              }
                            },
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
                      onTap: () {
                        // Set isButtonClicked to true when the button is tapped
                        setState(() {
                          isButtonClicked = true;
                        });
                        _signInWithEmailAndPassword(context);
                      },
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
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
            );
          },
        ),
      ),
    );
  }
}
