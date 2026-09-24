import 'package:flutter/foundation.dart';
import 'package:lista_compras/features/shopping/domain/entities/fetch_detail_shopping_list_entity.dart';
import 'package:lista_compras/features/shopping/model/fetch_detail_shopping_list_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailShoppingListRepository {
  final SupabaseClient client;

  DetailShoppingListRepository(this.client);

  Future<List<FetchDetailShoppingListEntity>> fetchShoppingListDetail(
    String shoppingListId,
  ) async {
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Usuário não autenticado.');
    }

    final itemsResponse = await client
        .from('shopping_list_items')
        .select(
          'id, list_id, product_id, name, '
          'checked, created_at',
        )
        .eq('list_id', shoppingListId)
        .order('created_at', ascending: true)
        .range(0, 100);

    final detailResponse = await client
        .from('shopping_list_item_detail')
        .select('list_item_id, item_price_total')
        .eq('list_id', shoppingListId)
        .eq('user_id', userId);

    final priceByListItemId = <String, num>{
      for (final row in detailResponse as List)
        if (row['list_item_id'] != null)
          row['list_item_id'] as String: row['item_price_total'] as num? ?? 0,
    };

    return (itemsResponse as List).map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      map['item_price_total'] = priceByListItemId[map['id']];
      return FetchDetailShoppingListModel.fromMap(map).toEntity();
    }).toList();
  }

  Future<double> fetchTotalShoppingList(String shoppingListId) async {
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Usuário não autenticado.');
    }

    final response = await client
        .from('shopping_list_item_detail')
        .select('item_price_total')
        .eq('list_id', shoppingListId)
        .eq('user_id', userId);

    final total = (response as List).fold<double>(
      0.0,
      (acc, row) =>
          acc + ((row['item_price_total'] as num?)?.toDouble() ?? 0.0),
    );

    debugPrint(
      '[total] list=$shoppingListId user=$userId '
      'rows=${response.length} total=$total data=$response',
    );
    return total;
  }
}
