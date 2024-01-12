import 'package:e_commerce/helpers/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/blocs/auth_bloc/auth_bloc.dart';
import 'package:e_commerce/blocs/auth_bloc/auth_event.dart';
import 'package:e_commerce/blocs/auth_bloc/auth_state.dart';
import 'package:e_commerce/cubit/user_cubit.dart';
import 'package:e_commerce/cubit/role_cubit.dart';
import 'package:e_commerce/screens/shop_owner/create_shop_success_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _selectedRole = 'End User';
  late final AuthBloc authBloc;
  final _formKey = GlobalKey<FormState>();
 bool isButtonClicked = false; 


  void movetoHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpEvent(
              username: _userNameController.text,
              email: _emailController.text,
              password: _passwordController.text,
              role: _selectedRole,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            try {
              if (state is AuthAuthenticated) {
                DocumentSnapshot? userSnapshot =
                    await FirebaseFirestore.instance.collection('users').doc(state.user.uid).get();

                Map<String, dynamic>? userData = userSnapshot?.data() as Map<String, dynamic>?;

                if (userData == null) {
                  throw Exception("User data not found");
                }

                String userRole = userData['role'] ?? 'End User';
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
                  Navigator.pushReplacementNamed(context, "/home");
                }
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            } catch (error) {
              print("Error during authentication: $error");
              // Handle the error as needed
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: ClipRRect(
                            child: Image.asset(
                              'assets/images/econmmerce.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fitWidth,
                            ),
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
                        buildTextField(
                          text: "Enter Username",
                          icon: Icons.person_2_outlined,
                          isPasswordType: false,
                          controller: _userNameController,
                          validator: (value) => isButtonClicked && value?.isEmpty == true ? 'Username cannot be empty' : null,
                          isButtonEnabled: isButtonClicked,
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          style: GoogleFonts.questrial(
                            textStyle: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          text: "Enter Email",
                          icon: Icons.mail_outline,
                          isPasswordType: false,
                          controller: _emailController,
                          validator: (value) => isButtonClicked && value?.isEmpty == true ? 'Email Id cannot be empty' : null,
                          isButtonEnabled: isButtonClicked,
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          text: "Enter Password",
                          icon: Icons.lock_outline,
                          isPasswordType: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (isButtonClicked && value?.isEmpty == true) {
                              return 'Password cannot be empty';
                            } else if (value!.length < 6) {
                              return 'Password length should be at least 6';
                            } else {
                              return null;
                            }
                          },
                          isButtonEnabled: isButtonClicked,
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          text: "Confirm Password",
                          icon: Icons.lock_outline,
                          isPasswordType: true,
                          controller: _confirmPasswordController,
                          validator: (value) {
                            if (isButtonClicked && value?.isEmpty == true) {
                              return 'Confirm Password cannot be empty';
                            } else if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            } else {
                              return null;
                            }
                          },
                          isButtonEnabled: isButtonClicked,
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                        // Set isButtonClicked to true when the button is tapped
                        setState(() {
                          isButtonClicked = true;
                        });
                        movetoHome(context);
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
              );
            },
          ),
        ),
      ),
    );
  }
}
