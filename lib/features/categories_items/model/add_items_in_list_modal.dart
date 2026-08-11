import 'package:lista_compras/features/categories_items/domain/entity/add_items_in_list_entity.dart';

class AddItemsInListModal {
  final String listId;
  final String productId;
  final String name;
  final bool checked;

  AddItemsInListModal({
    required this.listId,
    required this.productId,
    required this.name,
    required this.checked,
  });

  factory AddItemsInListModal.fromMap(Map<String, dynamic> map) {
    return AddItemsInListModal(
      listId: map['list_id'] as String,
      productId: map['product_id'] as String,
      name: map['name'] as String,
      checked: map['checked'] == true ? true : false,
    );
  }

  AddItemsInListEntity toEntity() {
    return AddItemsInListEntity(
      listId: listId,
      productId: productId,
      name: name,
      checked: checked,
    );
  }
}
