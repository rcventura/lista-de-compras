// Classe base de todos os eventos de autenticação.
// "abstract" significa que ninguém cria AuthEvent diretamente,
// apenas suas subclasses.
abstract class AuthEvent {}

// Evento disparado quando o usuário clica em "Entrar".
// Carrega email e senha que vieram do formulário.
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