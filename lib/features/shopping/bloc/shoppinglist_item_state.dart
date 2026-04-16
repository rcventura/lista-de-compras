import '../domain/entities/Fetch_detail_shopping_list_entity.dart';

abstract class ShoppingListItemState {}

class ShoppingListItemInitial extends ShoppingListItemState {}

class ShoppingListItemLoading extends ShoppingListItemState {}

class ShoppingListItemFetchSuccess extends ShoppingListItemState {
  final List<FetchDetailShoppingListEntity> items;

  ShoppingListItemFetchSuccess(this.items);
}

class ShoppingListItemAddSuccess extends ShoppingListItemState {}

class ShoppingListItemUpdateSuccess extends ShoppingListItemState {}

class ShoppingListItemDeleteSuccess extends ShoppingListItemState {}

class ShoppingListItemError extends ShoppingListItemState {
  final String message;

  ShoppingListItemError(this.message);
}
