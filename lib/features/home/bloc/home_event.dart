abstract class HomeEvent {}

class HomeFetchShoppingListsRequest extends HomeEvent {}

class HomeShoppingListDetailedRequested extends HomeEvent {
  final String shoppingListId;
  HomeShoppingListDetailedRequested(this.shoppingListId);
}

class HomeLogoutRequest extends HomeEvent {}

class HomeRefreshShoppingListsRequest extends HomeEvent {}

class HomeDeleteShoppingList extends HomeEvent {
  final String shoppingListId;
  HomeDeleteShoppingList(this.shoppingListId);
}
