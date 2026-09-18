import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/shopping/bloc/create_detail_item_shoppinglist_event.dart';
import 'package:lista_compras/features/shopping/bloc/create_detail_item_shoppinglist_state.dart';
import 'package:lista_compras/features/shopping/data/repositories/create_detail_item_shopping_list_repository.dart';
import 'package:lista_compras/features/shopping/domain/entities/create_detail_item_shopping_list_entity.dart';
import 'package:lista_compras/features/shopping/domain/usecases/create_detail_item_shopping_list_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class CreateDetailItemShoppinglistBloc
    extends
        Bloc<
          CreateDetailItemShoppinglistEvent,
          CreateDetailItemShoppinglistState
        > {
  late final CreateDetailItemShoppingListRepository
  _detailItemShoppingListRepository;
  late final CreateDetailItemShoppingListUsecase
  _createDetailItemShoppingListUsecase;

  CreateDetailItemShoppinglistBloc()
    : super(DetailItemSShoppingListItemInitial()) {
    _detailItemShoppingListRepository = CreateDetailItemShoppingListRepository(
      Supabase.instance.client,
    );
    _createDetailItemShoppingListUsecase = CreateDetailItemShoppingListUsecase(
      _detailItemShoppingListRepository,
    );

    on<CreateDetailItemRequest>(_onCreateDetailItemRequest);
    on<FetchDetailItemShoppingListRequested>(
      _onFetchDetailItemShoppingListRequested,
    );
    //on<DetailItemUpdateShoppingListRequested>(_onUpdateDetailitemShoppingListItemRequested);
  }

  Future<void> _onCreateDetailItemRequest(
    CreateDetailItemRequest event,
    Emitter<CreateDetailItemShoppinglistState> emit,
  ) async {
    emit(DetailItemShoppingListItemLoading());
    try {
      final createDetailItem = await _createDetailItemShoppingListUsecase
          .createDetailItemShoppingList(
            detailItem: CreateDetailItemShoppingListEntity(
              listId: event.detailItem.listId,
              productId: event.detailItem.productId,
              userId: event.detailItem.userId,
              listItemId: event.detailItem.listItemId,
              itemName: event.detailItem.itemName,
              itemBrand: event.detailItem.itemBrand,
              itemQuantity: event.detailItem.itemQuantity,
              itemType: event.detailItem.itemType,
              itemPrice: event.detailItem.itemPrice,
              isPromotional: event.detailItem.isPromotional,
              itemPricePromotional: event.detailItem.itemPricePromotional,
              itemDueDate: event.detailItem.itemDueDate,
              itemNotes: event.detailItem.itemNotes,
              itemPriceTotal: event.detailItem.itemPriceTotal,
              itemFractionalPrice: event.detailItem.itemFractionalPrice,
            ),
          );
      emit(DetailItemShoppingListAddSuccess(createDetailItem));
    } catch (e) {
      print('aa $e');
      emit(
        DetailItemShoppingListError(
          'Erro ao carregar itens1. Tente novamente.',
        ),
      );
    }
  }

  Future<void>
  _onFetchDetailItemShoppingListRequested(
    FetchDetailItemShoppingListRequested event,
    Emitter<CreateDetailItemShoppinglistState> emit,
  ) async {
    emit(DetailItemShoppingListItemLoading());
    try {
      final detailItem = await _detailItemShoppingListRepository.fetchDetailitemShoppingList(
        event.shoppingListId,
        event.productId,
        event.listItemId
      );

      if (detailItem == null) {
        emit(DetailItemShoppingListItemNotFound());
        return;
      }

      emit(DetailItemShoppingListItemFetchSuccess(detailItem));
    } catch (e) {
      emit(
        DetailItemShoppingListError(
          'Error ao carregar os dados do item, tente novamente',
        ),
      );
    }
  }
}

//   Future<void> _onUpdateDetailitemShoppingListItemRequested(
//     DetailItemUpdateShoppingListRequested event,
//     Emitter<CreateDetailItemShoppinglistState> emit,
//   ) async {
//     emit(DetailSShoppingListItemLoading());

//     try {
//       final updates = <String, dynamic>{
//         if (event.name != null) 'name': event.name,
//         if (event.quantity != null) 'quantity': event.quantity,
//         if (event.price != null) 'price': event.price,
//         if (event.checked != null) 'checked': event.checked,
//       };

//       await Supabase.instance.client
//           .from('shopping_list_items')
//           .update(updates)
//           .eq('id', event.itemId);

//       emit(DetailSShoppingListItemUpdateSuccess());
//     } catch (e) {
//       emit(
//         DetailItemShoppingListError('Erro ao atualizar item. Tente novamente.'),
//       );
//     }
//   }
// }
