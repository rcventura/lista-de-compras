import 'package:flutter/foundation.dart';

import '../model/auth_repository.dart';
import '../model/user_model.dart';

enum AuthStatus { idle, loading, success, error }

/// ViewModel de autenticação.
/// Responsabilidade única: gerenciar estado e lógica de autenticação (SRP).
/// Não conhece widgets — apenas expõe estado e métodos (separação de concerns).
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  AuthViewModel(this._repository);

  // ── Estado ──────────────────────────────────────────────────────────────

  AuthStatus _status = AuthStatus.idle;
  UserModel? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;

  // ── Ações ────────────────────────────────────────────────────────────────

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setStatus(AuthStatus.loading);

    try {
      _user = await _repository.login(email: email, password: password);
      _setStatus(AuthStatus.success);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setStatus(AuthStatus.error);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setStatus(AuthStatus.loading);

    try {
      _user = await _repository.register(
        name: name,
        email: email,
        password: password,
      );
      _setStatus(AuthStatus.success);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setStatus(AuthStatus.error);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    _setStatus(AuthStatus.loading);

    try {
      await _repository.forgotPassword(email: email);
      _setStatus(AuthStatus.success);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setStatus(AuthStatus.error);
    }
  }

  void resetStatus() {
    _errorMessage = null;
    _setStatus(AuthStatus.idle);
  }

  // ── Privado ──────────────────────────────────────────────────────────────

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }
}
