import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../home/model/shoppinglist_model.dart';
import 'shoppinglist_event.dart';
import 'shoppinglist_state.dart';

class ShoppinglistBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  ShoppinglistBloc() : super(ShoppingListInitial()) {
    on<FetchShoppingListsRequested>(_onFetchShoppingListsRequested);
    on<FetchShoppingListDetailsRequested>(_onFetchShoppingListDetailsRequested);
    on<CreateShoppingListRequested>(_onCreateShoppingListRequested);
    on<DeleteShoppingListRequested>(_onDeleteShoppingListRequested);
  }

  Future<void> _onFetchShoppingListsRequested(
    FetchShoppingListsRequested event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(ShoppingListLoading());

    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    try {
      final response = await Supabase.instance.client
          .from('shopping_lists')
          .select()
          .eq('user_id', userId);

      final shoppingLists = (response as List)
          .map((item) => ShoppinglistModel.fromMap(item as Map<String, dynamic>))
          .toList();

      emit(ShoppingListFetchSuccess(shoppingLists));
    } catch (e) {
      emit(ShoppingListFetchError('Erro ao carregar listas. Tente novamente.'));
    }
  }

  Future<void> _onFetchShoppingListDetailsRequested(
    FetchShoppingListDetailsRequested event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(ShoppingListLoading());

    try {
      final response = await Supabase.instance.client
          .from('shopping_lists')
          .select()
          .eq('id', event.shoppingListId)
          .single();

      final shoppingList = ShoppinglistModel.fromMap(response);
      emit(ShoppingListDetailsFetchSuccess(shoppingList));
    } catch (e) {
      emit(ShoppingListFetchError('Erro ao carregar detalhes da lista. Tente novamente.'));
    }
  }

  Future<void> _onCreateShoppingListRequested(
    CreateShoppingListRequested event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(ShoppingListLoading());

    try {
      await Supabase.instance.client.from('shopping_lists').insert({
        'name': event.name,
        'local': event.location,
        'supermarket_name': event.supermarketName,
        'user_id': Supabase.instance.client.auth.currentUser?.id,
        'created_at': DateTime.now().toIso8601String(),
      });

      emit(ShoppingListCreationSuccess());
    } catch (e) {
      emit(ShoppingListFetchError('Erro ao criar lista. Tente novamente.'));
    }
  }

  Future<void> _onDeleteShoppingListRequested(
    DeleteShoppingListRequested event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(ShoppingListLoading());

    try {
      await Supabase.instance.client
          .from('shopping_lists')
          .delete()
          .eq('id', event.shoppingListId);

      emit(ShoppingListDeletionSuccess());
    } catch (e) {
      emit(ShoppingListFetchError('Erro ao deletar lista. Tente novamente.'));
    }
  }
}
