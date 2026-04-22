import 'package:lista_compras/features/auth/data/repositories/auth_repository.dart';

class CreateAccountUseCase  {
  late final AuthRepository repository;

  CreateAccountUseCase(this.repository);

  Future<void> createAccount({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.createAccount(
      name: name,
      email: email,
      password: password,
    );
  }
}
