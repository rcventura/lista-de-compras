abstract class DetailShoppinglistEvent {}

class DetailFetchShoppingListItemsRequested extends DetailShoppinglistEvent {
  final String shoppingListId;

   DetailFetchShoppingListItemsRequested(this.shoppingListId);
}

class DetailUpdateShoppingListItemRequested extends DetailShoppinglistEvent {
  final String itemId;
  final String? name;
  final int? quantity;
  final double? price;
  final bool? checked;

  DetailUpdateShoppingListItemRequested({
    required this.itemId,
    this.name,
    this.quantity,
    this.price,
    this.checked,
  });
}

class DetailDeleteShoppingListItemRequested extends DetailShoppinglistEvent {
  final String itemId;

  DetailDeleteShoppingListItemRequested(this.itemId);
}
