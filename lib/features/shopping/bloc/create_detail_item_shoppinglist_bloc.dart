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
      final createDetailItem = await _createDetailItemShoppingListUsecase
          .createDetailItemShoppingList(
            detailitem: CreateDetailItemShoppingListEntity(
              id: event.detailitem.id,
              createdAt: event.detailitem.createdAt,
              productId: event.detailitem.productId,
              listId: event.detailitem.listId,
              userId: event.detailitem.userId,
              itemName: event.detailitem.itemName,
              itemBrand: event.detailitem.itemBrand,
              itemPrice: event.detailitem.itemPrice,
              itemPricePromotional: event.detailitem.itemPricePromotional,
              isPromotional: event.detailitem.isPromotional,
              itemQuantity: event.detailitem.itemQuantity,
              itemType: event.detailitem.itemType,
              itemPriceTotal: event.detailitem.itemPriceTotal,
            ),
          );

      emit(DetailItemShoppingListItemFetchSuccess(createDetailItem));
    } catch (e) {
      emit(
        DetailItemShoppingListError('Erro ao carregar itens. Tente novamente.'),
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
