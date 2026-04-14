import 'package:lista_compras/features/auth/data/repositories/auth_repository.dart';
import 'package:lista_compras/features/auth/domain/entities/user_entity.dart';

class LoginUseCase {
  late final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    return repository.loginAccount(email: email, password: password);
  }
}