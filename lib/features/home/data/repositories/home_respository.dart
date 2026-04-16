import 'package:lista_compras/features/home/domain/entities/home_entity.dart';
import 'package:lista_compras/features/home/model/shoppinglist_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRespository {
  final SupabaseClient client;

  HomeRespository(this.client);

  Future<List<HomeEntity>> fetchShoppingList() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuário não autenticado.');
    }

    final response = await client
        .from('shopping_lists')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

        print('Resposta do Supabase: $response');

    return (response as List)
        .map((item) => ShoppinglistModel.fromMap(item).toEntity())
        .toList();
  }
}
