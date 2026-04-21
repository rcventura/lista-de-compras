import 'package:lista_compras/features/home/domain/entities/home_entity.dart';

abstract class HomeState {}

class HomeShoppingListInitial extends HomeState {}

class HomeShoppingListLoading extends HomeState {}

class HomeShoppingListFetchSuccess extends HomeState {
  final List<HomeEntity> shoppingLists;
  HomeShoppingListFetchSuccess(this.shoppingLists);
}

class HomeShoppingListFetchError extends HomeState {
  final String message;
  HomeShoppingListFetchError(this.message);
}
