abstract class AddItemsInListEvent {}

class AddItemsInListRequested extends AddItemsInListEvent {
  final String listId;
  final String productId;
  final String name;
  final bool checked;

  AddItemsInListRequested({
    required this.listId,
    required this.productId,
    required this.name,
    required this.checked,
  });
}
