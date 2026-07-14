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
        .select('id, name, local, created_at')
        .eq('user_id', userId)
        .gte('created_at', startOfMonth.toIso8601String())
        .lt('created_at', startOfNextMonth.toIso8601String())
        .order('created_at', ascending: false);

    return _mapShoppingListsWithItemsCount(response as List);
  }

  Future<List<HomeEntity>> searchShoppingList(List<String> query) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario nao autenticado.');
    }

    final response = await client
        .from('shopping_lists')
        .select('id, name, local, created_at')
        .eq('user_id', userId)
        .or(query.map((q) => 'name.ilike.%$q%').join(','));

    return _mapShoppingListsWithItemsCount(response as List);
  }

  Future<List<HomeEntity>> _mapShoppingListsWithItemsCount(
    List<dynamic> shoppingLists,
  ) async {
    if (shoppingLists.isEmpty) return [];

    final listIds = shoppingLists
        .map((item) => (item as Map<String, dynamic>)['id'] as String)
        .toList();

    final itemsResponse = await client
        .from('shopping_list_items')
        .select('list_id')
        .inFilter('list_id', listIds);

    final itemsCountByListId = <String, int>{};
    for (final item in itemsResponse as List) {
      final listId = (item as Map<String, dynamic>)['list_id'] as String;
      itemsCountByListId[listId] = (itemsCountByListId[listId] ?? 0) + 1;
    }

    return shoppingLists.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      map['items_count'] = itemsCountByListId[map['id']] ?? 0;

      return HomeShoppinglistModel.fromMap(map).toEntity();
    }).toList();
  }

  Future<String> _deleteShoppingList(String listId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario nao autenticado.');
    }

try {
    final response = await client
        .from('shopping_lists')
        .delete()
        .eq('list_id', listId);
      return 'Lista excluida com sucesso!';

  } catch (e) {
    throw Exception('Erro ao excluir lista: $e')
  }



}
