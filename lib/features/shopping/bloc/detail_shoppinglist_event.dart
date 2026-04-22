abstract class DetailShoppinglistEvent {}

class DetailFetchShoppingListItemsRequested extends DetailShoppinglistEvent {
  final String shoppingListId;
  final String shoppingListName;
  final DateTime dataCriacao;

   DetailFetchShoppingListItemsRequested(this.shoppingListId, this.shoppingListName, this.dataCriacao);

}

class DetailUpdateShoppingListItemRequested extends DetailShoppinglistEvent {
  final String itemId;
  final String? name;
  final int? quantity;
  final double? price;
  final bool? isChecked;

  DetailUpdateShoppingListItemRequested({
    required this.itemId,
    this.name,
    this.quantity,
    this.price,
    this.isChecked,
  });
}

class DetailDeleteShoppingListItemRequested extends DetailShoppinglistEvent {
  final String itemId;

  DetailDeleteShoppingListItemRequested(this.itemId);
}
