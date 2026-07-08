import 'package:lista_compras/features/shopping/domain/entities/current_shopping_list_entity.dart';

abstract class CurrentShoppingListState {}

class CurrentShoppingListInitial extends CurrentShoppingListState {}

class CurrentShoppingListLoaded extends CurrentShoppingListState {
  final CurrentShoppingListEntity currentShoppingList;

  CurrentShoppingListLoaded({required this.currentShoppingList});
}

class CurrentShoppingListUpdated extends CurrentShoppingListState {}
