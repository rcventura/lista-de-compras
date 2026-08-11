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

    on<CreateDetailItemRequest>(_onFetchDetailItemShoppingListRequested);
    //on<DetailItemUpdateShoppingListRequested>(_onUpdateDetailitemShoppingListItemRequested);
  }

  Future<void> _onFetchDetailItemShoppingListRequested(
    CreateDetailItemRequest event,
    Emitter<CreateDetailItemShoppinglistState> emit,
  ) async {
    emit(DetailItemShoppingListItemLoading());
    try {
      print('id: ${event.detailItem.id}');
      print('createdAt: ${event.detailItem.createdAt}');
      print('productId: ${event.detailItem.productId}');
      print('listId: ${event.detailItem.listId}');
      print('userId: ${event.detailItem.userId}');
      print('itemName: ${event.detailItem.itemName}');
      print('itemBrand: ${event.detailItem.itemBrand}');
      print('itemPrice: ${event.detailItem.itemPrice}');
      print('itemPricePromotional: ${event.detailItem.itemPricePromotional}');
      print('isPromotional: ${event.detailItem.isPromotional}');
      print('itemQuantity: ${event.detailItem.itemQuantity}');
      print('itemType: ${event.detailItem.itemType}');
      print('itemPriceTotal: ${event.detailItem.itemPriceTotal}');
      print('itemDetailId: ${event.detailItem.listItemId}');

      final createDetailItem = await _createDetailItemShoppingListUsecase
          .createDetailItemShoppingList(
            detailItem: CreateDetailItemShoppingListEntity(
              id: event.detailItem.id,
              createdAt: event.detailItem.createdAt,
              productId: event.detailItem.productId,
              listId: event.detailItem.listId,
              userId: event.detailItem.userId,
              itemName: event.detailItem.itemName,
              itemBrand: event.detailItem.itemBrand,
              itemPrice: event.detailItem.itemPrice,
              itemPricePromotional: event.detailItem.itemPricePromotional,
              isPromotional: event.detailItem.isPromotional,
              itemQuantity: event.detailItem.itemQuantity,
              itemType: event.detailItem.itemType,
              itemPriceTotal: event.detailItem.itemPriceTotal,
              listItemId: event.detailItem.listItemId,
            ),
          );
      emit(DetailItemShoppingListItemFetchSuccess(createDetailItem));
    } catch (e) {
       print('aa $e');
      emit(
        DetailItemShoppingListError('Erro ao carregar itens1. Tente novamente.'),
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
