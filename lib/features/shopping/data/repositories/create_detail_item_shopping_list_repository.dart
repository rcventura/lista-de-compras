import 'package:flutter/foundation.dart';
import 'package:lista_compras/features/shopping/domain/entities/create_detail_item_shopping_list_entity.dart';
import 'package:lista_compras/features/shopping/model/create_detail_item_shopping_list_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateDetailItemShoppingListRepository {
  final SupabaseClient client;

  CreateDetailItemShoppingListRepository(this.client);

  Future<CreateDetailItemShoppingListEntity?> fetchDetailitemShoppingList(
    String shoppingListId,
    String productId,
    String listItemId,
  ) async {
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Usuário não autenticado.');
    }

    final response = await client
        .from('shopping_list_item_detail')
        .select(
          'id, list_id, product_id, item_name, item_brand, '
          'item_price, item_price_promotional, is_promotional, item_quantity, item_type, '
          'item_price_total, item_due_date, item_notes, list_item_id, user_id, created_at, item_fractional_price',
        )
        .eq('list_id', shoppingListId)
        .eq('product_id', productId)
        .eq('list_item_id', listItemId)
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return CreateDetailItemShoppingListModel.fromMap(response).toEntity();
  }

  Future<CreateDetailItemShoppingListEntity> createDetailItem({
    required CreateDetailItemShoppingListEntity detailItem,
  }) async {
    final values = {
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
      'list_item_id': detailItem.listItemId,
      'item_fractional_price': detailItem.itemFractionalPrice,
    };

    // Se o item já tem detalhe, atualiza a linha existente em vez de inserir
    // outra — o total da lista soma item_price_total de todas as linhas.
    final listItemId = detailItem.listItemId;
    final existing = listItemId == null || listItemId.isEmpty
        ? null
        : await client
              .from('shopping_list_item_detail')
              .select('id')
              .eq('list_id', detailItem.listId)
              .eq('list_item_id', listItemId)
              .eq('user_id', detailItem.userId)
              .maybeSingle();

    debugPrint(
      '[detail] save list=${detailItem.listId} user=${detailItem.userId} '
      'existing=${existing?['id']} values=$values',
    );

    final data = existing != null
        ? await client
              .from('shopping_list_item_detail')
              .update(values)
              .eq('id', existing['id'])
              .select()
              .single()
        : await client
              .from('shopping_list_item_detail')
              .insert(values)
              .select()
              .single();

    final createDetalItemModel = CreateDetailItemShoppingListModel.fromMap(data);
    return createDetalItemModel.toEntity();
  }
}
