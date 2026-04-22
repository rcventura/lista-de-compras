import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/home/data/repositories/home_respository.dart';
import 'package:lista_compras/features/home/domain/usecases/fetch_shopping_list_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final HomeRespository _homeRespository;
  late final FetchShoppingListUsecase _fetchShoppingListUsecase;

  HomeBloc() : super(HomeShoppingListInitial()) {
    _homeRespository = HomeRespository(Supabase.instance.client);
    _fetchShoppingListUsecase = FetchShoppingListUsecase(_homeRespository);

    on<HomeFetchShoppingListsRequest>(_onFetchShoppingListsRequested);
  }

  // LIST SHOPPING LISTS
  Future<void> _onFetchShoppingListsRequested(
    HomeFetchShoppingListsRequest event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeShoppingListLoading());

    try {
      final shoppingLists = await _fetchShoppingListUsecase.fetchShoppingList();
      emit(HomeShoppingListFetchSuccess(shoppingLists));
    } catch (e) {
      emit(HomeShoppingListFetchError('Erro ao carregar listas. Tente novamente.'));
    }
  }
}
