import 'package:lista_compras/features/auth/domain/entities/user_entity.dart';
import 'package:lista_compras/features/auth/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient client;

  AuthRepository(this.client);

  // AUHTENTICATION - LOGIN
  Future<UserEntity> loginAccount({
    required String email,
    required String password,
  }) async {
    await client.auth.signInWithPassword(email: email, password: password);

    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuário não encontrado após login.');
    }

    final data = await client.from('users').select().eq('id', userId).single();

    final userModel = UserModel.fromMap(data);
    return userModel.toEntity();
  }

  // LOGOUT
  Future<void> logoutAccount() async {
       client.auth.signOut();
  }

  // CREATE ACCOUNT
  Future<UserEntity> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    await client.auth.signUp(email: email, password: password);

    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuário não encontrado após login.');
    }
    final data = await client.from('users').insert({
      'id': userId,
      'name': name,
      'email': email,
    })
    .select()
    .single();

    final userModel = UserModel.fromMap(data);
    return userModel.toEntity();
  }

  // FORGOT PASSWORD
  Future<void> forgotPasswordAccount({
    required String email,
  }) async {
    await client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'io.supabase.flutter://reset-password',
      );
  }
}
