import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/shopping/data/repositories/create_shopping_list_repository.dart';
import 'package:lista_compras/features/shopping/domain/usecases/create_shopping_list_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'create_shoppinglist_event.dart';
import 'create_shoppinglist_state.dart';

class CreateShoppinglistBloc
    extends Bloc<CreateShoppinglistEvent, CreateShoppingListState> {
  late final CreateShoppingListRepository _createShoppingListRepository;
  late final CreateShoppingListUsecase _createShoppingListUsecase;

  CreateShoppinglistBloc() : super(CreateShoppingListInitial()) {
    _createShoppingListRepository = CreateShoppingListRepository(
      Supabase.instance.client,
    );
    _createShoppingListUsecase = CreateShoppingListUsecase(
      _createShoppingListRepository,
    );

    on<CreateShoppingListRequested>(_onCreateShoppingListRequested);
  }

  // CREATE LIST
  Future<void> _onCreateShoppingListRequested(
    CreateShoppingListRequested event,
    Emitter<CreateShoppingListState> emit,
  ) async {
    emit(CreateShoppingListLoading());

    try {
      await _createShoppingListUsecase.createShoppingList(
        name: event.name,
        local: event.local,
        userId: event.userId,
        supermarketName: event.supermarketName,
      );

      emit(CreateShoppingListCreationSuccess(''));
    } catch (e) {
      emit(CreateShoppingListCreationError('Erro ao criar lista. Tente novamente. $e'));
    }
  }

  // Future<void> _onFetchShoppingListDetailsRequested(
  //   FetchShoppingListDetailsRequested event,
  //   Emitter<CreateShoppingListState> emit,
  // ) async {
  //   emit(ShoppingListLoading());

  //   try {
  //     final response = await Supabase.instance.client
  //         .from('shopping_lists')
  //         .select()
  //         .eq('id', event.shoppingListId)
  //         .single();

  //     final shoppingList = CreateShoppingListModel.fromMap(response);
  //     //    emit(ShoppingListDetailsFetchSuccess(shoppingList));
  //   } catch (e) {
  //     emit(
  //       ShoppingListFetchError(
  //         'Erro ao carregar detalhes da lista. Tente novamente.',
  //       ),
  //     );
  //   }
  // }

  // Future<void> _onDeleteShoppingListRequested(
  //   DeleteShoppingListRequested event,
  //   Emitter<CreateShoppingListState> emit,
  // ) async {
  //   emit(ShoppingListLoading());

  //   try {
  //     await Supabase.instance.client
  //         .from('shopping_lists')
  //         .delete()
  //         .eq('id', event.shoppingListId);

  //     emit(ShoppingListDeletionSuccess());
  //   } catch (e) {
  //     emit(ShoppingListFetchError('Erro ao deletar lista. Tente novamente.'));
  //   }
  // }
}
