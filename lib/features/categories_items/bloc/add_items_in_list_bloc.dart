import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/categories_items/bloc/add_items_in_list_event.dart';
import 'package:lista_compras/features/categories_items/bloc/add_items_in_list_state.dart';
import 'package:lista_compras/features/categories_items/data/add_items_in_list_repository.dart';
import 'package:lista_compras/features/categories_items/domain/usecase/add_items_in_list_usecase.dart';

import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'categories_items_event.dart';
import 'categories_items_state.dart';

class AddItemsInListBloc
    extends Bloc<AddItemsInListEvent, AddItemsInListState> {
  late final AddItemsInListRepository _addItemsInListRepository;
  late final AddItemsItemsUsecase _addItemsItemsUsecase;

  AddItemsInListBloc() : super(AddItemsInListInitial()) {
    _addItemsInListRepository = AddItemsInListRepository(
      Supabase.instance.client,
    );
    _addItemsItemsUsecase = AddItemsItemsUsecase(
      _addItemsInListRepository,
    );

    on<AddItemsInListRequested>(_onAddItemsInListRequested);
  }

  // CREATE LIST
  Future<void> _onAddItemsInListRequested(
    AddItemsInListRequested event,
    Emitter<AddItemsInListState> emit,
  ) async {
    emit(AddItemsInListLoading());

    try {
      await _addItemsItemsUsecase.addItemsInList(
        event.listId,
        event.productId,
        event.name,
        event.quantity,
        event.unit,
        event.checked,
        event.position,
        event.price
      );

      emit(AddItemsInListSuccess(''));
    } catch (e) {
      emit(AddItemsInListError('Erro ao criar lista. Tente novamente. $e'));
    }
  }
}
