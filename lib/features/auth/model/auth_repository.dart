import 'user_model.dart';

/// Contrato do repositório de autenticação.
/// Depender desta abstração (DIP) permite trocar a implementação
/// (mock, Firebase, REST) sem alterar ViewModel ou View.
abstract interface class AuthRepository {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> forgotPassword({required String email});

  Future<void> logout();
}
