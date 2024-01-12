
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}


 class AuthError extends AuthState {
  final String error;
  final String uniqueId; // Add a unique identifier

  const AuthError({required this.error, required this.uniqueId});

  @override
  List<Object?> get props => [error, uniqueId];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthError &&
          runtimeType == other.runtimeType &&
          error == other.error &&
          uniqueId == other.uniqueId;

  @override
  int get hashCode => error.hashCode ^ uniqueId.hashCode;
}


 