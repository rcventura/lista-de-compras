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
          'item_price_total, item_due_date, item_notes, list_item_id',
        )
        .eq('list_id', shoppingListId)
        .eq('product_id', productId)
        .single();

    return CreateDetailItemShoppingListModel.fromMap(response).toEntity();
  }

  Future<CreateDetailItemShoppingListEntity> createDetailItem({
    required CreateDetailItemShoppingListEntity detailItem,
  }) async {
    final data = await client
        .from('shopping_list_item_detail')
        .insert({
          'list_id': detailItem.listId, 
          'product_id': detailItem.productId, 
          'user_id': detailItem.userId,
          'item_name': detailItem.itemName, 
          'item_brand': detailItem.itemBrand,
          'item_price': detailItem.itemPrice,
          'item_price_promotional': detailItem.itemPricePromotional, 
          'is_promotional': detailItem.isPromotional, 
          'item_quantity': detailItem.itemQuantity, 
          'item_type': detailItem.itemType,
          'item_price_total': detailItem.itemPriceTotal, 
          'item_due_date': detailItem.itemDueDate, 
          'item_notes': detailItem.itemNotes,
          'list_item_id': detailItem.listItemId
  })
        .select()
        .single();

    final createDetalItemModel = CreateDetailItemShoppingListModel.fromMap(data);
    return createDetalItemModel.toEntity();
  }
}
