import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/shopping/data/repositories/detail_shopping_list_repository.dart';
import 'package:lista_compras/features/shopping/domain/entities/fetch_detail_shopping_list_entity.dart';
import 'package:lista_compras/features/shopping/domain/usecases/fetch_detail_shopping_list_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'detail_shoppinglist_event.dart';
import 'detail_shoppinglist_state.dart';

class DetailShoppinglistBloc
    extends Bloc<DetailShoppinglistEvent, DetailShoppinglistState> {
      late final DetailShoppingListRepository _detailShoppingListRepository;
      late final FetchDetailShoppingListUsecase _fetchDetailShoppingListUsecase;
      

  DetailShoppinglistBloc() : super(DetailSShoppingListItemInitial()) {
    _detailShoppingListRepository = DetailShoppingListRepository(Supabase.instance.client);
    _fetchDetailShoppingListUsecase = FetchDetailShoppingListUsecase(_detailShoppingListRepository);

    on<DetailFetchShoppingListItemsRequested>(_onFetchShoppingListItemsRequested);
    on<DetailUpdateShoppingListItemRequested>(_onUpdateShoppingListItemRequested);
    on<DetailDeleteShoppingListItemRequested>(_onDeleteShoppingListItemRequested);
  }

  Future<void> _onFetchShoppingListItemsRequested(
    DetailFetchShoppingListItemsRequested event,
    Emitter<DetailShoppinglistState> emit,
  ) async {
    emit(DetailSShoppingListItemLoading());

    try {

      final List<FetchDetailShoppingListEntity> items = await _fetchDetailShoppingListUsecase.fetchShoppingListDetail(event.shoppingListId);
      emit(DetailSShoppingListItemFetchSuccess(items));
    } catch (e) {
      emit(DetailSShoppingListItemError('Erro ao carregar itens. Tente novamente.'));
    }
  }

  Future<void> _onUpdateShoppingListItemRequested(
    DetailUpdateShoppingListItemRequested event,
    Emitter<DetailShoppinglistState> emit,
  ) async {
    emit(DetailSShoppingListItemLoading());

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

      emit(DetailSShoppingListItemUpdateSuccess());
    } catch (e) {
      emit(DetailSShoppingListItemError('Erro ao atualizar item. Tente novamente.'));
    }
  }

  Future<void> _onDeleteShoppingListItemRequested(
    DetailDeleteShoppingListItemRequested event,
    Emitter<DetailShoppinglistState> emit,
  ) async {
    emit(DetailSShoppingListItemLoading());

    try {
      await Supabase.instance.client
          .from('shopping_list_items')
          .delete()
          .eq('id', event.itemId);

      emit(DetailSShoppingListItemDeleteSuccess());
    } catch (e) {
      emit(DetailSShoppingListItemError('Erro ao deletar item. Tente novamente.'));
    }
  }
}
