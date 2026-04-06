import 'auth_repository.dart';
import 'user_model.dart';

/// Implementação mock — substitua por Firebase / REST sem tocar no ViewModel.
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (password.length < 6) {
      throw Exception('E-mail ou senha inválidos.');
    }

    return UserModel(
      id: 'usr_001',
      name: 'Usuário Teste',
      email: email,
    );
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return UserModel(
      id: 'usr_002',
      name: name,
      email: email,
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
