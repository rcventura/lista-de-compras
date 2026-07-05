abstract class CreateShoppingListState {}

class CreateShoppingListInitial extends CreateShoppingListState {}

class CreateShoppingListLoading extends CreateShoppingListState {}

class CreateShoppingListCreationSuccess extends CreateShoppingListState {
  final String shoppingListId;
  final String shoppingListName;
  final String shoppingListCreatedAt;
  final String locate;

  CreateShoppingListCreationSuccess({
    required this.shoppingListId,
    required this.shoppingListName,
    required this.shoppingListCreatedAt,
    required this.locate,
  });
}

class CreateShoppingListCreationError extends CreateShoppingListState {
  final String message;

  CreateShoppingListCreationError(this.message);
}
