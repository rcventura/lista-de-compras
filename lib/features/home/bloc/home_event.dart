abstract class HomeEvent {}

class HomeFetchShoppingListsRequest extends HomeEvent {}

class HomeShoppingListDetailedRequested extends HomeEvent {
  final String shoppingListId;
  HomeShoppingListDetailedRequested(this.shoppingListId);
}

class HomeShoppingListFilterRequest extends HomeEvent {
  final DateTime startDate;
  final DateTime endDate;

  HomeShoppingListFilterRequest(this.startDate, this.endDate);
}

class HomeLogoutRequest extends HomeEvent {}

class HomeRefreshShoppingListsRequest extends HomeEvent {}

class HomeDeleteShoppingList extends HomeEvent {
  final String shoppingListId;
  HomeDeleteShoppingList(this.shoppingListId);
}
