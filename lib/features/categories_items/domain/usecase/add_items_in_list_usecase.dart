import 'package:lista_compras/features/categories_items/data/add_items_in_list_repository.dart';
import 'package:lista_compras/features/categories_items/domain/entity/add_items_in_list_entity.dart';


class AddItemsItemsUsecase {
  late final AddItemsInListRepository repository;

  AddItemsItemsUsecase(this.repository);

  Future<void> addItemsInList(
        String id,
        String listId,
        String productId,
        String name,
        String quantity,
        String unit,
        bool checked,
        int position,
        double price
  ) {
    return repository.addItemInList( 
      AddItemsInListEntity(
        id: id,
        listId: listId,
        productId: productId,
        name: name,
        quantity: quantity,
        unit: unit,
        checked: checked,
        position: position,
        price: price
      )
    );
  }
}