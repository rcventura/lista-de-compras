abstract class HomeEvent {}

class FetchHomeShoppingListsRequest extends HomeEvent {}
class ShoppingListDetailedRequested extends HomeEvent {
  final String shoppingListId;

  ShoppingListDetailedRequested(this.shoppingListId);
}

class DeleteShoppingListRequest extends HomeEvent {
  final String id;

  DeleteShoppingListRequest(this.id);
}

class LogoutRequest extends HomeEvent {}
class RefreshShoppingListsRequest extends HomeEvent {}
class DetailShoppingListRequest extends HomeEvent {
  final String id;

  DetailShoppingListRequest(this.id);
}