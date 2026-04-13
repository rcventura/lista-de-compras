class ShoppingListItemModel {
  final String id;
  final String shoppingListId;
  final String productId;
  final String name;
  final int quantity;
  final String unit;
  final bool isChecked;
  final int? order;
  final DateTime? createdAt;
  

  ShoppingListItemModel({
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

  factory ShoppingListItemModel.fromMap(Map<String, dynamic> map) {
    return ShoppingListItemModel(
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

  ShoppingListItemModel copyWith({
    String? id,
    String? shoppingListId,
    String? productId,
    String? name,
    int? quantity,
    bool? isChecked,
    int? order,
    DateTime? createdAt,
  }) {
    return ShoppingListItemModel(
      
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
}
