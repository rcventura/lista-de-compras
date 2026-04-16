import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/forgot_password_usercase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/create_usecase.dart';
import '../data/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'auth_event.dart';
import 'auth_state.dart';

// O BLoC recebe eventos (AuthEvent) e emite estados (AuthState).
// Pense nele como o "cérebro" que fica entre a UI e o Supabase.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final AuthRepository _authRepository;
  late final LoginUseCase _loginUseCase;
  late final CreateAccountUseCase _createAccountUseCase;
  late final LogoutUsecase _logoutUsecase;
  late final ForgotPasswordUsercase _forgotPasswordUsercase;

  // O estado inicial quando o BLoC é criado é AuthInitial.
  AuthBloc() : super(AuthInitial()) {
    _authRepository = AuthRepository(Supabase.instance.client);
    _loginUseCase = LoginUseCase(_authRepository);
    _createAccountUseCase = CreateAccountUseCase(_authRepository);
    _logoutUsecase = LogoutUsecase(_authRepository);
    _forgotPasswordUsercase = ForgotPasswordUsercase(_authRepository);
    
    // Aqui registramos o handler para o evento LoginRequested.
    // Toda vez que a UI disparar LoginRequested, esse código roda.
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CreateAccountRequested>(_onCreateAccountRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event, // o evento com email e senha
    Emitter<AuthState> emit, // função que envia o novo estado para a UI
  ) async {
    // 1. Avisa a UI que está carregando
    emit(AuthLoading());

    try {
      final user = await _loginUseCase.loginAccount(
        email: event.email,
        password: event.password,
      );

      emit(AuthSuccess(user));
    } on AuthApiException catch (e) {
      if (e.statusCode == '400') {
        emit(AuthError('Email ou senha inválidos.'));
      } else {
        emit(AuthError(e.message));
      }
    } catch (_) {
      emit(AuthError('Erro ao entrar. Tente novamente.'));
    }
  }

  Future<void> _onCreateAccountRequested(
    CreateAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _createAccountUseCase.createAccount(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      emit(RegisterSuccess());
    } on AuthApiException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Erro ao criar conta. Tente novamente.'));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _forgotPasswordUsercase.forgotPasswordAccount();
      emit(SendResetPasswordSuccess());
    } on AuthApiException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Erro ao solicitar reset. Tente novamente.'));
    }
  }

  // Fazer logout.
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _logoutUsecase.logountAccount();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError('Erro ao sair. Tente novamente.'));
    }
  }
}
