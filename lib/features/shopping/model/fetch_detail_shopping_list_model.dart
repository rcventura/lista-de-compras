import 'package:lista_compras/features/shopping/domain/entities/fetch_detail_shopping_list_entity.dart';

class FetchDetailShoppingListModel {
  final String id;
  final String shoppingListId;
  final String productId;
  final String name;
  final bool checked;
  final DateTime? createdAt;
  final double? priceTotal;

  FetchDetailShoppingListModel({
    required this.id,
    required this.shoppingListId,
    required this.productId,
    required this.name,
    required this.checked,
    this.createdAt,
    this.priceTotal,
  });

  factory FetchDetailShoppingListModel.fromMap(Map<String, dynamic> map) {
    return FetchDetailShoppingListModel(
      id: map['id'] as String,
      shoppingListId: map['list_id'] as String,
      productId: map['product_id'] as String,
      name: map['name'] as String,
      checked: map['checked'] as bool? ?? false,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      priceTotal: map['item_price_total'] != null
          ? (map['item_price_total'] as num).toDouble()
          : null,
    );
  }

  FetchDetailShoppingListModel copyWith({
    String? id,
    String? shoppingListId,
    String? productId,
    String? name,
    bool? checked,
    DateTime? createdAt,
    double? priceTotal,
  }) {
    return FetchDetailShoppingListModel(

      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      checked: checked ?? this.checked,
      createdAt: createdAt,
      priceTotal: priceTotal ?? this.priceTotal,
    );
  }

  FetchDetailShoppingListEntity toEntity() {
    return FetchDetailShoppingListEntity(
      id: id,
      shoppingListId: shoppingListId,
      productId: productId,
      name: name,
      checked: checked,
      createdAt: createdAt,
      priceTotal: priceTotal,
    );
  }
}
