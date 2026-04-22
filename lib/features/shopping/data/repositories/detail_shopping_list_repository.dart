import 'package:lista_compras/features/shopping/domain/entities/fetch_detail_shopping_list_entity.dart';
import 'package:lista_compras/features/shopping/model/fetch_detail_shopping_list_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailShoppingListRepository {
  final SupabaseClient client;

  DetailShoppingListRepository(this.client);

  Future<List<FetchDetailShoppingListEntity>> fetchShoppingListDetail(String shoppingListId) async {
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Usuário não autenticado.');
    }

    final resposne = await client
        .from('shopping_list_items')
        .select()
        .eq('shopping_list_id', shoppingListId);

    return (resposne as List)
        .map((item) => FetchDetailShoppingListModel.fromMap(item).toEntity())
        .toList();
  }
}
