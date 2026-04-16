import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/home/domain/usecases/fetch_shopping_list_usecase.dart';
import 'package:lista_compras/features/shopping/data/repositories/fetch_detail_shopping_list_repository.dart';
import 'package:lista_compras/features/shopping/domain/usecases/fetch_detail_shopping_list_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../model/fetch_detail_shopping_list_model.dart';
import 'shoppinglist_item_event.dart';
import 'shoppinglist_item_state.dart';

class ShoppinglistItemBloc
    extends Bloc<ShoppingListItemEvent, ShoppingListItemState> {
      late final FetchDetailShoppingListRepository _detailShoppingListRepository;
      late final FetchDetailShoppingListUsecase _fetchDetailShoppingListUsecase;
      

  ShoppinglistItemBloc() : super(ShoppingListItemInitial()) {
    _detailShoppingListRepository = FetchDetailShoppingListRepository(Supabase.instance.client, _detailShoppingListRepository.shoppingListId);
    _fetchDetailShoppingListUsecase = FetchDetailShoppingListUsecase(_detailShoppingListRepository);

    on<FetchShoppingListItemsRequested>(_onFetchShoppingListItemsRequested);
    on<AddShoppingListItemRequested>(_onAddShoppingListItemRequested);
    on<UpdateShoppingListItemRequested>(_onUpdateShoppingListItemRequested);
    on<DeleteShoppingListItemRequested>(_onDeleteShoppingListItemRequested);
    on<ToggleShoppingListItemRequested>(_onToggleShoppingListItemRequested);
  }

  Future<void> _onFetchShoppingListItemsRequested(
    FetchShoppingListItemsRequested event,
    Emitter<ShoppingListItemState> emit,
  ) async {
    emit(ShoppingListItemLoading());

    try {

      final items = await _fetchDetailShoppingListUsecase.fetchShoppingListDetail();
   //   emit(ShoppingListItemFetchSuccess(items));
    } catch (e) {
      emit(ShoppingListItemError('Erro ao carregar itens. Tente novamente.'));
    }
  }

  Future<void> _onAddShoppingListItemRequested(
    AddShoppingListItemRequested event,
    Emitter<ShoppingListItemState> emit,
  ) async {
    emit(ShoppingListItemLoading());

    try {
      await Supabase.instance.client.from('shopping_list_items').insert({
        'shopping_list_id': event.shoppingListId,
        'name': event.name,
        'quantity': event.quantity,
        'price': event.price,
        'is_checked': false,
      });

      emit(ShoppingListItemAddSuccess());
    } catch (e) {
      emit(ShoppingListItemError('Erro ao adicionar item. Tente novamente.'));
    }
  }

  Future<void> _onUpdateShoppingListItemRequested(
    UpdateShoppingListItemRequested event,
    Emitter<ShoppingListItemState> emit,
  ) async {
    emit(ShoppingListItemLoading());

    try {
      final updates = <String, dynamic>{
        if (event.name != null) 'name': event.name,
        if (event.quantity != null) 'quantity': event.quantity,
        if (event.price != null) 'price': event.price,
        if (event.isChecked != null) 'is_checked': event.isChecked,
      };

      await Supabase.instance.client
          .from('shopping_list_items')
          .update(updates)
          .eq('id', event.itemId);

      emit(ShoppingListItemUpdateSuccess());
    } catch (e) {
      emit(ShoppingListItemError('Erro ao atualizar item. Tente novamente.'));
    }
  }

  Future<void> _onDeleteShoppingListItemRequested(
    DeleteShoppingListItemRequested event,
    Emitter<ShoppingListItemState> emit,
  ) async {
    emit(ShoppingListItemLoading());

    try {
      await Supabase.instance.client
          .from('shopping_list_items')
          .delete()
          .eq('id', event.itemId);

      emit(ShoppingListItemDeleteSuccess());
    } catch (e) {
      emit(ShoppingListItemError('Erro ao deletar item. Tente novamente.'));
    }
  }

  Future<void> _onToggleShoppingListItemRequested(
    ToggleShoppingListItemRequested event,
    Emitter<ShoppingListItemState> emit,
  ) async {
    try {
      await Supabase.instance.client
          .from('shopping_list_items')
          .update({'is_checked': event.isChecked}).eq('id', event.itemId);

      emit(ShoppingListItemUpdateSuccess());
    } catch (e) {
      emit(ShoppingListItemError('Erro ao atualizar item. Tente novamente.'));
    }
  }
}
