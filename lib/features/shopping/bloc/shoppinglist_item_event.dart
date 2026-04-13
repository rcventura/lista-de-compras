abstract class ShoppingListItemEvent {}

// ─────────────────────────────────────────────
// Eventos dos Itens da Lista de Compras
// ─────────────────────────────────────────────

class FetchShoppingListItemsRequested extends ShoppingListItemEvent {
  final String shoppingListId;

  FetchShoppingListItemsRequested(this.shoppingListId);
}

class AddShoppingListItemRequested extends ShoppingListItemEvent {
  final String shoppingListId;
  final String name;
  final int quantity;
  final double? price;

  AddShoppingListItemRequested({
    required this.shoppingListId,
    required this.name,
    required this.quantity,
    this.price,
  });
}

class UpdateShoppingListItemRequested extends ShoppingListItemEvent {
  final String itemId;
  final String? name;
  final int? quantity;
  final double? price;
  final bool? isChecked;

  UpdateShoppingListItemRequested({
    required this.itemId,
    this.name,
    this.quantity,
    this.price,
    this.isChecked,
  });
}

class DeleteShoppingListItemRequested extends ShoppingListItemEvent {
  final String itemId;

  DeleteShoppingListItemRequested(this.itemId);
}

class ToggleShoppingListItemRequested extends ShoppingListItemEvent {
  final String itemId;
  final bool isChecked;

  ToggleShoppingListItemRequested({
    required this.itemId,
    required this.isChecked,
  });
}
