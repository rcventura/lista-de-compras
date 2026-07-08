import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/shopping/cubit/current_shopping_list_state.dart';
import 'package:lista_compras/features/shopping/domain/entities/current_shopping_list_entity.dart';

class CurrentShoppingListCubit extends Cubit<CurrentShoppingListState> {
  CurrentShoppingListCubit() : super(CurrentShoppingListInitial());

  void setCurrentList({
    required String id,
    required String name,
    required String local,
    required String createdAt,
  }) {
    emit(
      CurrentShoppingListLoaded(
        currentShoppingList: CurrentShoppingListEntity(
          id: id,
          name: name,
          local: local,
          createdAt: createdAt,
        ),
      ),
    );
  }

  void addItemToShoppingList(String item) {
    // Logic to add an item to the shopping list
    emit(CurrentShoppingListUpdated());
  }

  void removeItemFromShoppingList(String item) {
    // Logic to remove an item from the shopping list
    emit(CurrentShoppingListUpdated());
  }

  void clear() {
    emit(CurrentShoppingListInitial());
  }
}
