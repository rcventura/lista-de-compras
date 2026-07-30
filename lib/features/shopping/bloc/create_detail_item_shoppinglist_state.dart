import 'package:lista_compras/features/shopping/domain/entities/create_detail_item_shopping_list_entity.dart';

abstract class CreateDetailItemShoppinglistState {}

class DetailItemSShoppingListItemInitial extends CreateDetailItemShoppinglistState {}

class DetailItemShoppingListItemLoading extends CreateDetailItemShoppinglistState {}

class DetailItemShoppingListItemFetchSuccess extends CreateDetailItemShoppinglistState {
  final CreateDetailItemShoppingListEntity item;

  DetailItemShoppingListItemFetchSuccess(
    this.item,
  );
}

class DetailItemShoppingListAddSuccess extends CreateDetailItemShoppinglistState {}

class DetailItemShoppingListUpdateSuccess extends CreateDetailItemShoppinglistState {}

class DetailItemShoppingListError extends CreateDetailItemShoppinglistState {
  final String message;

  DetailItemShoppingListError(this.message);
}
