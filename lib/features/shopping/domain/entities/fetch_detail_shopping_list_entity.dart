class FetchDetailShoppingListEntity {
  final String id;
  final String shoppingListId;
  final String productId;
  final String name;
  final int quantity;
  final String unit;
  final bool isChecked;
  final int? order;
  final DateTime? createdAt;

  FetchDetailShoppingListEntity({
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
}
