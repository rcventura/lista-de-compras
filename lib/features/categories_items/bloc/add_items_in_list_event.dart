abstract class AddItemsInListEvent {}

class AddItemsInListRequested extends AddItemsInListEvent {
  final String listId;
  final String productId;
  final String name;
  final double quantity;
  final String unit;
  final bool checked;
  final double price;

  AddItemsInListRequested({
    required this.listId,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.checked,
    required this.price,
  });
}
