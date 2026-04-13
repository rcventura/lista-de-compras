import '../../home/model/shoppinglist_model.dart';

abstract class ShoppingListState {}

class ShoppingListInitial extends ShoppingListState {}

class ShoppingListLoading extends ShoppingListState {}

class ShoppingListCreationSuccess extends ShoppingListState {}

class ShoppingListDeletionSuccess extends ShoppingListState {}

class ShoppingListFetchSuccess extends ShoppingListState {
  final List<ShoppinglistModel> shoppingLists;

  ShoppingListFetchSuccess(this.shoppingLists);
}

class ShoppingListDetailsFetchSuccess extends ShoppingListState {
  final ShoppinglistModel shoppingList;

  ShoppingListDetailsFetchSuccess(this.shoppingList);
}

class ShoppingListFetchError extends ShoppingListState {
  final String message;

  ShoppingListFetchError(this.message);
}
