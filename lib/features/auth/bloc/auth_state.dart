import '../domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;

  AuthSuccess(this.user);
}

class RegisterSuccess extends AuthState {}

class SendResetPasswordSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}