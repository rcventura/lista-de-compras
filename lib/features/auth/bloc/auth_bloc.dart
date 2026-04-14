import 'package:flutter_bloc/flutter_bloc.dart';
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
  // O estado inicial quando o BLoC é criado é AuthInitial.
  AuthBloc() : super(AuthInitial()) {
    _authRepository = AuthRepository(Supabase.instance.client);
    _loginUseCase = LoginUseCase(_authRepository);

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
      final user = await _loginUseCase(
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
      emit(AuthError('Erro ao entrar. Tente novamente.'));
    }
  }

  Future<void> _onCreateAccountRequested(
    CreateAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: event.email,
        password: event.password,
      );

      final userId = response.user?.id;
      if (userId != null) {
        await Supabase.instance.client.from('users').insert({
          'id': userId,
          'name': event.name,
          'email': event.email,
        });
      }

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
      await Supabase.instance.client.auth.resetPasswordForEmail(
        event.email,
        redirectTo: 'io.supabase.flutter://reset-password',
      );
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
      await Supabase.instance.client.auth.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError('Erro ao sair. Tente novamente.'));
    }
  }
}
