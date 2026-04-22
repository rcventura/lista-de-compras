abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class LogoutRequested extends AuthEvent {}

class CreateAccountRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  CreateAccountRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}

class ResetPasswordRequested extends AuthEvent {
  final String email;

  ResetPasswordRequested({required this.email});
}
