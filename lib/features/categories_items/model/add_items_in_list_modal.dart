import 'package:lista_compras/features/categories_items/domain/entity/add_items_in_list_entity.dart';

class AddItemsInListModal {
  final String listId;
  final String productId;
  final String name;
  final int quantity;
  final String unit;
  final bool checked;
  final int position;
  final double price;

  AddItemsInListModal({
    required this.listId,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.checked,
    required this.position,
    required this.price,
  });

  factory AddItemsInListModal.fromMap(Map<String, dynamic> map) {
    return AddItemsInListModal(
      listId: map['list_id'] as String,
      productId: map['product_id'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      unit: map['unit'] as String,
      checked: map['checked'] == true ? true : false,
      position: map['position'] as int,
      price: (map['price'] as num).toDouble(),
    );
  }

  AddItemsInListEntity toEntity() {
    return AddItemsInListEntity(
      listId: listId,
      productId: productId,
      name: name,
      quantity: quantity,
      unit: unit,
      checked: checked,
      position: position,
      price: price,
    );
  }
}
