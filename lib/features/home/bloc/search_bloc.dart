import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/home/bloc/search_event.dart';
import 'package:lista_compras/features/home/bloc/search_state.dart';
import 'package:lista_compras/features/home/data/repositories/home_respository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  late final HomeRespository _homeRespository;

  SearchBloc() : super(SearchInitial()) {
    _homeRespository = HomeRespository(Supabase.instance.client);

    on<SearchShoppingListsRequest>(_onSearchShoppingListsRequested);
  }

  Future<void> _onSearchShoppingListsRequested(
    SearchShoppingListsRequest event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    try {
      final searchResults = await _homeRespository.searchShoppingList(
        event.query,
      );
      emit(SearchFetchSuccess(searchResults));
    } catch (e) {
      emit(SearchFetchError('Erro ao buscar listas. Tente novamente.'));
    }
  }
}
