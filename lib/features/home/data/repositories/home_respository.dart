import 'package:lista_compras/features/home/domain/entities/home_entity.dart';
import 'package:lista_compras/features/home/model/home_shoppinglist_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRespository {
  final SupabaseClient client;

  HomeRespository(this.client);

  Future<List<HomeEntity>> fetchShoppingList() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario nao autenticado.');
    }

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startOfNextMonth = DateTime(now.year, now.month + 1, 1);

    final response = await client
        .from('shopping_lists')
        .select()
        .eq('user_id', userId)
        .gte('created_at', startOfMonth.toIso8601String())
        .lt('created_at', startOfNextMonth.toIso8601String())
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => HomeShoppinglistModel.fromMap(item).toEntity())
        .toList();
  }

  Future<List<HomeEntity>> searchShoppingList(List<String> query) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario nao autenticado.');
    }

    final response = await client
        .from('shopping_lists')
        .select()
        .eq('user_id', userId)
        .or(query.map((q) => 'name.ilike.%$q%').join(','));

    return (response as List)
        .map((item) => HomeShoppinglistModel.fromMap(item).toEntity())
        .toList();
  }
}
