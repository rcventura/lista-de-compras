
class FetchDetailShoppingListEntity {
  final String id;
  final String shoppingListId;
  final String productId;
  final String name;
  final int quantity;
  final String unit;
  final bool checked;
  final int? order;
  final DateTime? createdAt;
  final double? price;

  FetchDetailShoppingListEntity({
    required this.id,
    required this.shoppingListId,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.order,
    required this.checked,
    this.createdAt,
    required this.price,
  });
}
