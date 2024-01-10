// auth_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    // Register event handlers in the constructor
    on<SignInEvent>(_mapSignInEventToState);
    on<SignUpEvent>(_mapSignUpEventToState);
    on<SignOutEvent>(_mapSignOutEventToState);
  }


  Future<void> _mapSignInEventToState(SignInEvent event, Emitter<AuthState> emit) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      User? user = userCredential.user;

    if (user != null) {
      // Delay to allow time for authentication state to propagate
      await Future.delayed(Duration(seconds: 1));
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthError(error: 'Sign-In failed. Please check cred.', uniqueId: DateTime.now().toString()));
      }
    } catch (e) {
      emit(AuthError(error: 'Sign-In failed. Please check.', uniqueId: DateTime.now().toString()));
    }
  }


  Future<void> _mapSignUpEventToState(SignUpEvent event, Emitter<AuthState> emit) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Add user data to Firestore
    
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'username': event.username,
          'email': event.email,
          'role': event.role,
          'shops':[]
        });
      
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthError(error: 'Sign-Up failed. Please check cred.', uniqueId: DateTime.now().toString()));
      }
    } catch (e) {
      emit(AuthError(error: 'Sign-Up failed. Please check.', uniqueId: DateTime.now().toString()));
    }
  }

  Future<void> _mapSignOutEventToState(SignOutEvent event,Emitter<AuthState> emit) async {
    try {
      await _auth.signOut();
     
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(error: 'Sign-Out failed. Please check.', uniqueId: DateTime.now().toString()));
    }
  }
}