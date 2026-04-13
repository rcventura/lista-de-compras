import '../model/shoppinglist_model.dart';

abstract class HomeState {}

class ShoppingListInitial extends HomeState {}
class ShoppingListLoading extends HomeState {}
class ShoppingListFetchSuccess extends HomeState {
  final List<ShoppinglistModel> shoppingLists;

  ShoppingListFetchSuccess(this.shoppingLists);
}
class ShoppingListFetchError extends HomeState {
  final String message;

  ShoppingListFetchError(this.message);
}

class ShoppingListDetailedSuccess extends HomeState {
  final ShoppinglistModel shoppingList;

  ShoppingListDetailedSuccess(this.shoppingList);
}