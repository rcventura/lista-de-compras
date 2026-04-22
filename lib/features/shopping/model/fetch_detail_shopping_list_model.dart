import 'package:lista_compras/features/shopping/domain/entities/fetch_detail_shopping_list_entity.dart';

class FetchDetailShoppingListModel {
  final String id;
  final String shoppingListId;
  final String productId;
  final String name;
  final int quantity;
  final String unit;
  final bool isChecked;
  final int? order;
  final DateTime? createdAt;
  

  FetchDetailShoppingListModel({
    required this.id,
    required this.shoppingListId,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.order,
    required this.isChecked,
    this.createdAt,  
  });

  factory FetchDetailShoppingListModel.fromMap(Map<String, dynamic> map) {
    return FetchDetailShoppingListModel(
      id: map['id'] as String,
      shoppingListId: map['list_id'] as String,
      productId: map['product_id'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      unit: map['unit'] as String,
      isChecked: map['is_checked'] as bool? ?? false,
      order: map['position'] as int?,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  FetchDetailShoppingListModel copyWith({
    String? id,
    String? shoppingListId,
    String? productId,
    String? name,
    int? quantity,
    bool? isChecked,
    int? order,
    DateTime? createdAt,
  }) {
    return FetchDetailShoppingListModel(
      
      id: id ?? this.id,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit,
      isChecked: isChecked ?? this.isChecked,
      order: order ?? this.order,
      createdAt: createdAt,);
  }

  FetchDetailShoppingListEntity toEntity() {
    return FetchDetailShoppingListEntity(
      id: id,
      shoppingListId: shoppingListId,
      productId: productId,
      name: name,
      quantity: quantity,
      unit: unit,
      isChecked: isChecked,
      order: order,
      createdAt: createdAt,
    );
  }
}
