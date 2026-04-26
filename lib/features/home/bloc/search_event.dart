abstract class SearchEvent {}

class SearchShoppingListsRequest extends SearchEvent {
  final List<String> query;
  SearchShoppingListsRequest(this.query);
}