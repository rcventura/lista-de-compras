import '../model/user_model.dart';

// Classe base de todos os estados de autenticação.
// O BLoC sempre vai "emitir" um desses estados abaixo.
abstract class AuthState {}

// Estado inicial — nada aconteceu ainda.
class AuthInitial extends AuthState {}

// Estado de carregamento — aguardando resposta do Supabase.
class AuthLoading extends AuthState {}

// Login bem-sucedido — carrega o usuário logado.
class AuthSuccess extends AuthState {
  final UserModel user;

  AuthSuccess(this.user);
}

// Conta criada com sucesso — aguardando navegação.
class RegisterSuccess extends AuthState {}

// Envio de email para reset de senha bem-sucedido — aguardando navegação.
class SendResetPasswordSuccess extends AuthState {}

// Algo deu errado — carrega a mensagem de erro.
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
