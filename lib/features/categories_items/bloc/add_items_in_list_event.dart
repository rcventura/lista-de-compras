abstract class AddItemsInListEvent {}

class AddItemsInListRequested extends AddItemsInListEvent {
  final String listId;
  final String productId;
  final String name;
  final String quantity;
  final String unit;
  final bool checked;
  final int position;
  final double price;

  AddItemsInListRequested({
    required this.listId,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.checked,
    required this.position,
    required this.price,
  });
}
