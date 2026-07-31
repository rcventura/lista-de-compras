import 'package:lista_compras/features/shopping/domain/entities/create_detail_item_shopping_list_entity.dart';
import 'package:lista_compras/features/shopping/model/create_detail_item_shopping_list_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateDetailItemShoppingListRepository {
  final SupabaseClient client;

  CreateDetailItemShoppingListRepository(this.client);

  Future<CreateDetailItemShoppingListEntity> fetchDetailitemShoppingList(
    String shoppingListId,
    String productId,
  ) async {
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Usuário não autenticado.');
    }

    final response = await client
        .from('shopping_list_item_detail')
        .select(
          'id, list_id, product_id, item_name, item_brand, '
          'item_price, item_price_promotional, is_promotional, item_quantity, item_type '
          'item_price_total, item_due_date, item_notes',
        )
        .eq('list_id', shoppingListId)
        .eq('product_id', productId)
        .single();

    return CreateDetailItemShoppingListModel.fromMap(response).toEntity();
  }

  Future<CreateDetailItemShoppingListEntity> createDetailItem({
    required CreateDetailItemShoppingListEntity detailitem,
  }) async {
    final data = await client
        .from('shopping_list_item_detail')
        .insert({
          'list_id': detailitem.listId, 
          'product_id': detailitem.productId, 
          'user_id': detailitem.userId,
          'item_name': detailitem.itemName, 
          'item_brand': detailitem.itemBrand,
          'item_price': detailitem.itemPrice,
          'item_price_promotional': detailitem.itemPricePromotional, 
          'is_promotional': detailitem.isPromotional, 
          'item_quantity': detailitem.itemQuantity, 
          'item_type': detailitem.itemType,
          'item_price_total': detailitem.itemPriceTotal, 
          'item_due_date': detailitem.itemDueDate, 
          'item_notes': detailitem.itemNotes,
  })
        .select()
        .single();

    final createDetalItemModel = CreateDetailItemShoppingListModel.fromMap(data);
    return createDetalItemModel.toEntity();
  }
}
