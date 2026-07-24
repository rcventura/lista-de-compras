import 'package:lista_compras/features/categories_items/domain/entity/add_items_in_list_entity.dart';
import 'package:lista_compras/features/categories_items/model/add_items_in_list_modal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddItemsInListRepository {
  final SupabaseClient client;
  AddItemsInListRepository(this.client);

  Future<AddItemsInListEntity> addItemInList(AddItemsInListEntity item) async {
    try {
      final response = await client
          .from('shopping_list_items')
          .insert([
            {
              'list_id': item.listId,
              'product_id': item.productId,
              'name': item.name,
              'quantity': item.quantity,
              'unit': item.unit,
              'checked': item.checked,
              'position': item.position,
              'price': item.price
            }
          ])
          .select()
          .single();
          
      return AddItemsInListModal.fromMap(response).toEntity();
    } catch (e) {
      throw Exception('Failed to add item to list: $e');
    }
  }
}
