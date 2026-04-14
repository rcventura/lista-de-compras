import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../model/shoppinglist_model.dart';
import 'home_event.dart';
import 'home_state.dart';


class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(ShoppingListInitial()) {
    on<FetchShoppingListsRequest>(_onFetchShoppingListsRequested);
    on<ShoppingListDetailedRequested>(_onShoppingListDetailedRequested);
  }

  Future<void> _onFetchShoppingListsRequested(
    FetchShoppingListsRequest event,
    Emitter<HomeState> emit,
  ) async {
    emit(ShoppingListLoading());

    try {
      final response = await Supabase.instance.client
          .from('shopping_lists')
          .select()
          .eq('user_id', Supabase.instance.client.auth.currentUser?.id ?? '')
          .order('created_at', ascending: false);

      final shoppingLists = response
          .map((item) => ShoppinglistModel.fromMap(item))
          .toList();

      emit(ShoppingListFetchSuccess(shoppingLists));
    } catch (e) {
      emit(ShoppingListFetchError('Erro ao carregar listas. Tente novamente.'));
    }
  }

  Future<void> _onShoppingListDetailedRequested(
    ShoppingListDetailedRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(ShoppingListLoading());

    try {
      final response = await Supabase.instance.client
          .from('shopping_lists')
          .select()
          .eq('id', event.shoppingListId)
          .single();

      final shoppingList = ShoppinglistModel.fromMap(response);
      emit(ShoppingListDetailedSuccess(shoppingList));
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao buscar detalhes da lista: $e');
      emit(ShoppingListFetchError('Erro ao carregar detalhes da lista. Tente novamente.'));
    }
  }
}