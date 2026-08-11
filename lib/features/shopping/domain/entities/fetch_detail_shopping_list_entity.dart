
class FetchDetailShoppingListEntity {
  final String id;
  final String shoppingListId;
  final String productId;
  final String name;
  final bool checked;
  final DateTime? createdAt;

  FetchDetailShoppingListEntity({
    required this.id,
    required this.shoppingListId,
    required this.productId,
    required this.name,
    required this.checked,
    this.createdAt,
  });
}
