import 'package:lista_compras/features/auth/data/repositories/auth_repository.dart';

class LogoutUsecase {
  late final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<void> logountAccount() {
    return repository.logoutAccount();
  }
}
