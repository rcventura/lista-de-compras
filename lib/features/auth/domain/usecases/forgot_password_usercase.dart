import 'package:lista_compras/features/auth/data/repositories/auth_repository.dart';

class ForgotPasswordUsercase {
  late final AuthRepository repository;

  ForgotPasswordUsercase(this.repository);

  Future<void> forgotPasswordAccount(String email) async {
    return repository.forgotPasswordAccount(email: email);
  }
}
