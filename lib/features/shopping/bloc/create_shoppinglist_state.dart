import 'package:lista_compras/features/shopping/domain/entities/create_shopping_list_entity.dart';

abstract class CreateShoppingListState {}

class ShoppingListInitial extends CreateShoppingListState {}

class ShoppingListLoading extends CreateShoppingListState {}

class ShoppingListCreationSuccess extends CreateShoppingListState {}

class ShoppingListDeletionSuccess extends CreateShoppingListState {}

class ShoppingListFetchSuccess extends CreateShoppingListState {
  final List<CreateShoppingListEntity> shoppingLists;

  ShoppingListFetchSuccess(this.shoppingLists);
}

class ShoppingListDetailsFetchSuccess extends CreateShoppingListState {
  final CreateShoppingListEntity shoppingList;

  ShoppingListDetailsFetchSuccess(this.shoppingList);
}

class ShoppingListFetchError extends CreateShoppingListState {
  final String message;

  ShoppingListFetchError(this.message);
}
