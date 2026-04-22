import 'package:lista_compras/features/shopping/domain/entities/create_shopping_list_entity.dart';
import 'package:lista_compras/features/shopping/model/create_shopping_list_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateShoppingListRepository {
  final SupabaseClient client;

  CreateShoppingListRepository(this.client);

  //CREATE LIST
  Future<CreateShoppingListEntity> createShoppingList({
    required String name,
    required String userId,
    required String local,
    String? supermarketName,
  }) async {
    final data = await client
        .from('shopping_lists')
        .insert({
          'name': name,
          'local': local,
          'supermarket_name': supermarketName,
          'user_id': userId,
        })
        .select()
        .single();

    final createShoppingListModel = CreateShoppingListModel.fromMap(data);
    return createShoppingListModel.toEntity();
  }
}
