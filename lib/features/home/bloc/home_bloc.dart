import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/home/data/repositories/home_respository.dart';
import 'package:lista_compras/features/home/domain/usecases/delete_shopping_list_usecase.dart';

import 'package:lista_compras/features/home/domain/usecases/Filter_shopping_list_usecase.dart';
import 'package:lista_compras/features/home/domain/usecases/fetch_shopping_list_usecase%20copy.dart';

import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final HomeRespository _homeRespository;
  late final FetchShoppingListUsecase _fetchShoppingListUsecase;
  late final DeleteShoppingListUsecase _deleteShoppingListUseCase;
  late final FilterShoppingListUsecase _filterShoppingListUseCase;

  HomeBloc() : super(HomeShoppingListInitial()) {
    _homeRespository = HomeRespository(Supabase.instance.client);
    _fetchShoppingListUsecase = FetchShoppingListUsecase(_homeRespository);
    _deleteShoppingListUseCase = DeleteShoppingListUsecase(_homeRespository);
    _filterShoppingListUseCase = FilterShoppingListUsecase(_homeRespository);

    on<HomeFetchShoppingListsRequest>(_onFetchShoppingListsRequested);
    on<HomeDeleteShoppingList>(_onDeleteShoppingList);
    on<HomeShoppingListFilterRequest>(_onFilterFetchShoppingList);
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
      emit(
        HomeShoppingListFetchError('Erro ao carregar listas. Tente novamente.'),
      );
    }
  }

  // FILTER SHOPPING LIST
  Future<void> _onFilterFetchShoppingList(
    HomeShoppingListFilterRequest event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeShoppingListLoading());
    try {
      final shoppingList = await _filterShoppingListUseCase.filterShoppingList(
        event.startDate,
        event.endDate
      );
      print('ahhhhhhhh $shoppingList');
      emit(HomeShoppingListFetchSuccess(shoppingList));
    } catch (e) {
      emit(
        HomeShoppingListFetchError('Erro ao carregar listas. Tente novamente.'),
      );
    }
  }

  Future<void> _onDeleteShoppingList(
    HomeDeleteShoppingList event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeShoppingListLoading());
    try {
      await _deleteShoppingListUseCase(event.shoppingListId);

      emit(DeleteShoppingListSuccess('Lista deletada com sucesso!'));
      add(HomeFetchShoppingListsRequest());
    } catch (e) {
      emit(
        HomeShoppingListFetchError('Erro ao deletar listas. Tente novamente.'),
      );
    }
  }
}
