abstract class CreateShoppingListState {}

class CreateShoppingListInitial extends CreateShoppingListState {}

class CreateShoppingListLoading extends CreateShoppingListState {}

class CreateShoppingListCreationSuccess extends CreateShoppingListState {
  final String shoppingListId;
  final String shoppingListName;

  CreateShoppingListCreationSuccess({
    required this.shoppingListId,
    required this.shoppingListName,
  });
}

class CreateShoppingListCreationError extends CreateShoppingListState {
  final String message;

  CreateShoppingListCreationError(this.message);
}
