class AddItemsInListEntity {
  final String? id;
  final String listId;
  final String productId;
  final String name;
  final bool checked;

  AddItemsInListEntity({
    this.id,
    required this.listId,
    required this.productId,
    required this.name,
    required this.checked,
  });
}
