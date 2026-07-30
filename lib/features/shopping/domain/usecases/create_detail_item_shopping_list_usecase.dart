import 'package:lista_compras/features/shopping/data/repositories/create_detail_item_shopping_list_repository.dart';
import 'package:lista_compras/features/shopping/domain/entities/create_detail_item_shopping_list_entity.dart';

class CreateDetailItemShoppingListUsecase {
  late final CreateDetailItemShoppingListRepository repository;

  CreateDetailItemShoppingListUsecase(this.repository);

  Future<CreateDetailItemShoppingListEntity> createDetailItemShoppingList({
required CreateDetailItemShoppingListEntity detailitem
  }) {
    return repository.createDetailItem(
      detailitem: CreateDetailItemShoppingListEntity(
        id: detailitem.id,
        createdAt: detailitem.createdAt,
        productId: detailitem.productId,
        listId: detailitem.listId,
        userId: detailitem.userId,
        itemName: detailitem.itemName,
        itemBrand: detailitem.itemBrand,
        itemPrice: detailitem.itemPrice,
        itemPricePromotional: detailitem.itemPricePromotional,
        isPromotional: detailitem.isPromotional,
        itemQuantity: detailitem.itemQuantity,
        itemType: detailitem.itemType,
        itemPriceTotal: detailitem.itemPriceTotal,
        itemDueDate: detailitem.itemDueDate,
        itemNotes: detailitem.itemNotes
      ),
    );
  }
}