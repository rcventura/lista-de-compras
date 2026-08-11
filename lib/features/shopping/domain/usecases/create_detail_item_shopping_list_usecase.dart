import 'package:lista_compras/features/shopping/data/repositories/create_detail_item_shopping_list_repository.dart';
import 'package:lista_compras/features/shopping/domain/entities/create_detail_item_shopping_list_entity.dart';

class CreateDetailItemShoppingListUsecase {
  late final CreateDetailItemShoppingListRepository repository;

  CreateDetailItemShoppingListUsecase(this.repository);

  Future<CreateDetailItemShoppingListEntity> createDetailItemShoppingList({
required CreateDetailItemShoppingListEntity detailItem
  }) {
    return repository.createDetailItem(
      detailItem: CreateDetailItemShoppingListEntity(
        id: detailItem.id,
        createdAt: detailItem.createdAt,
        productId: detailItem.productId,
        listId: detailItem.listId,
        userId: detailItem.userId,
        itemName: detailItem.itemName,
        itemBrand: detailItem.itemBrand,
        itemPrice: detailItem.itemPrice,
        itemPricePromotional: detailItem.itemPricePromotional,
        isPromotional: detailItem.isPromotional,
        itemQuantity: detailItem.itemQuantity,
        itemType: detailItem.itemType,
        itemPriceTotal: detailItem.itemPriceTotal,
        itemDueDate: detailItem.itemDueDate,
        itemNotes: detailItem.itemNotes,
        listItemId: detailItem.listItemId,
      ),
    );
  }
}