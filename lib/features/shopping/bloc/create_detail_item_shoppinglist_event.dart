import 'package:lista_compras/features/shopping/domain/entities/create_detail_item_shopping_list_entity.dart';

abstract class CreateDetailItemShoppinglistEvent {}

class CreateDetailItemRequest extends CreateDetailItemShoppinglistEvent {
  final CreateDetailItemShoppingListEntity detailitem;

  CreateDetailItemRequest(this.detailitem);
  
}

class FetchDetailItemShoppingListRequested extends CreateDetailItemShoppinglistEvent {
  final String shoppingListId;
  final String productId;

   FetchDetailItemShoppingListRequested(this.shoppingListId, this.productId);
}

class DetailItemUpdateShoppingListRequested extends CreateDetailItemShoppinglistEvent {
  final String itemId;
  final String? name;
  final int? quantity;
  final double? price;
  final bool? checked;

  DetailItemUpdateShoppingListRequested({
    required this.itemId,
    this.name,
    this.quantity,
    this.price,
    this.checked,
  });
}
