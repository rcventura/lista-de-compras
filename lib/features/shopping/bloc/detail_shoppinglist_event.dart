abstract class DetailShoppinglistEvent {}

class DetailFetchShoppingListItemsRequested extends DetailShoppinglistEvent {
  final String shoppingListId;

   DetailFetchShoppingListItemsRequested(this.shoppingListId);
}

class DetailUpdateShoppingListItemRequested extends DetailShoppinglistEvent {
  final String itemId;
  final String? name;
  final double? quantity;
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

class DetailFetchTotalShoppingListRequested extends DetailShoppinglistEvent {
  final String shoppingListId;

  DetailFetchTotalShoppingListRequested(this.shoppingListId);
}

class DetailDeleteShoppingListItemRequested extends DetailShoppinglistEvent {
  final String itemId;

  DetailDeleteShoppingListItemRequested(this.itemId);
}
