import 'package:lista_compras/features/auth/domain/entities/user_entity.dart';
import 'package:lista_compras/features/auth/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient client;

  AuthRepository(this.client);

  Future<UserEntity> login({
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
}
