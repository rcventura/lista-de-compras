import 'package:lista_compras/features/shopping/domain/entities/fetch_detail_shopping_list_entity.dart';

abstract class DetailShoppinglistState {}

class DetailSShoppingListItemInitial extends DetailShoppinglistState {}

class DetailSShoppingListItemLoading extends DetailShoppinglistState {}

class DetailSShoppingListItemFetchSuccess extends DetailShoppinglistState {
  final List<FetchDetailShoppingListEntity> items;

  DetailSShoppingListItemFetchSuccess(this.items);
}

class DetailSShoppingListItemAddSuccess extends DetailShoppinglistState {}

class DetailSShoppingListItemUpdateSuccess extends DetailShoppinglistState {}

class DetailSShoppingListItemDeleteSuccess extends DetailShoppinglistState {}

class DetailSShoppingListItemError extends DetailShoppinglistState {
  final String message;

  DetailSShoppingListItemError(this.message);
}
