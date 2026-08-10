class AddItemsInListEntity {
  final String listId;
  final String productId;
  final String name;
  final double quantity;
  final String unit;
  final bool checked;
  final double price;

  AddItemsInListEntity({
    required this.listId,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.checked,
    required this.price,
  });
}
