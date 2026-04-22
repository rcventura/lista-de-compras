abstract class CreateShoppingListState {}

class CreateShoppingListInitial extends CreateShoppingListState {}

class CreateShoppingListLoading extends CreateShoppingListState {}

class CreateShoppingListCreationSuccess extends CreateShoppingListState {
  final String shoppingListId;
  CreateShoppingListCreationSuccess(this.shoppingListId);
}

class CreateShoppingListCreationError extends CreateShoppingListState {
  final String message;

  CreateShoppingListCreationError(this.message);
}
