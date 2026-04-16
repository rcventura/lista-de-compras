import 'package:lista_compras/features/home/domain/entities/home_entity.dart';

abstract class HomeState {}

class ShoppingListInitial extends HomeState {}
class ShoppingListLoading extends HomeState {}
class ShoppingListFetchSuccess extends HomeState {
  final List<HomeEntity> shoppingLists;

  ShoppingListFetchSuccess(this.shoppingLists);
}
class ShoppingListFetchError extends HomeState {
  final String message;

  ShoppingListFetchError(this.message);
}

class ShoppingListDetailedSuccess extends HomeState {
  final HomeEntity shoppingList;

  ShoppingListDetailedSuccess(this.shoppingList);
}