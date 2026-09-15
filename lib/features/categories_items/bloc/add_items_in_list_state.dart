abstract class AddItemsInListState {}

class AddItemsInListInitial extends AddItemsInListState {}

class AddItemsInListLoading extends AddItemsInListState {}

class AddItemsInListSuccess extends AddItemsInListState {
  final String message;
  final String listItemId;

  AddItemsInListSuccess(this.message, {this.listItemId = ''});
}

class AddItemsInListError extends AddItemsInListState {
  final String message;

  AddItemsInListError(this.message);
}
