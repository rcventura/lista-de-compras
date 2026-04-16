import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/home/data/repositories/home_respository.dart';
import 'package:lista_compras/features/home/domain/usecases/fetch_shopping_list_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../model/shoppinglist_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final HomeRespository _homeRespository;
  late final FetchShoppingListUsecase _fetchShoppingListUsecase;

  HomeBloc() : super(ShoppingListInitial()) {
    _homeRespository = HomeRespository(Supabase.instance.client);
    _fetchShoppingListUsecase = FetchShoppingListUsecase(_homeRespository);

    on<FetchHomeShoppingListsRequest>(_onFetchShoppingListsRequested);
    on<ShoppingListDetailedRequested>(_onShoppingListDetailedRequested);
  }

  Future<void> _onFetchShoppingListsRequested(
    FetchHomeShoppingListsRequest event,
    Emitter<HomeState> emit,
  ) async {
    emit(ShoppingListLoading());

    try {
      final shoppingLists = await _fetchShoppingListUsecase.fetchShoppingList();
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
      //  emit(ShoppingListDetailedSuccess(shoppingList));
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao buscar detalhes da lista: $e');
      emit(
        ShoppingListFetchError(
          'Erro ao carregar detalhes da lista. Tente novamente.',
        ),
      );
    }
  }
}
