import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/shopping/data/repositories/create_shopping_list_repository.dart';
import 'package:lista_compras/features/shopping/domain/usecases/create_shopping_list_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../home/model/shoppinglist_model.dart';
import 'create_shoppinglist_event.dart';
import 'create_shoppinglist_state.dart';

class CreateShoppinglistBloc
    extends Bloc<CreateShoppinglistEvent, CreateShoppingListState> {
  late final CreateShoppingListRepository _createShoppingListRepository;
  late final CreateShoppingListUsecase _createShoppingListUsecase;

  CreateShoppinglistBloc() : super(ShoppingListInitial()) {
    _createShoppingListRepository = CreateShoppingListRepository(
      Supabase.instance.client,
    );
    _createShoppingListUsecase = CreateShoppingListUsecase(
      _createShoppingListRepository,
    );

    on<FetchShoppingListsRequested>(_onFetchShoppingListsRequested);
    on<FetchShoppingListDetailsRequested>(_onFetchShoppingListDetailsRequested);
    on<CreateShoppingListRequested>(_onCreateShoppingListRequested);
    on<DeleteShoppingListRequested>(_onDeleteShoppingListRequested);
  }

  Future<void> _onFetchShoppingListsRequested(
    FetchShoppingListsRequested event,
    Emitter<CreateShoppingListState> emit,
  ) async {
    emit(ShoppingListLoading());

    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    try {
      final response = await Supabase.instance.client
          .from('shopping_lists')
          .select()
          .eq('user_id', userId);

      final shoppingLists = (response as List)
          .map(
            (item) => ShoppinglistModel.fromMap(item as Map<String, dynamic>),
          )
          .toList();

      //emit(ShoppingListFetchSuccess(shoppingLists));
    } catch (e) {
      emit(ShoppingListFetchError('Erro ao carregar listas. Tente novamente.'));
    }
  }

  Future<void> _onFetchShoppingListDetailsRequested(
    FetchShoppingListDetailsRequested event,
    Emitter<CreateShoppingListState> emit,
  ) async {
    emit(ShoppingListLoading());

    try {
      final response = await Supabase.instance.client
          .from('shopping_lists')
          .select()
          .eq('id', event.shoppingListId)
          .single();

      final shoppingList = ShoppinglistModel.fromMap(response);
      //    emit(ShoppingListDetailsFetchSuccess(shoppingList));
    } catch (e) {
      emit(
        ShoppingListFetchError(
          'Erro ao carregar detalhes da lista. Tente novamente.',
        ),
      );
    }
  }

  Future<void> _onDeleteShoppingListRequested(
    DeleteShoppingListRequested event,
    Emitter<CreateShoppingListState> emit,
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

  Future<void> _onCreateShoppingListRequested(
    CreateShoppingListRequested event,
    Emitter<CreateShoppingListState> emit,
  ) async {
    emit(ShoppingListLoading());

    try {
      await _createShoppingListUsecase.createShoppingList(
        name: event.name,
        local: event.local,
        userId: event.userId,
        supermarketName: event.supermarketName,
      );

      emit(ShoppingListCreationSuccess());
    } catch (e) {
      emit(ShoppingListFetchError('Erro ao criar lista. Tente novamente. $e'));
    }
  }
}
