abstract class AddItemsInListState {}

class AddItemsInListInitial extends AddItemsInListState {}

class AddItemsInListLoading extends AddItemsInListState {}

class AddItemsInListSuccess extends AddItemsInListState {
  final String message;

  AddItemsInListSuccess(this.message);
}

class AddItemsInListError extends AddItemsInListState {
  final String message;

  AddItemsInListError(this.message);
}
