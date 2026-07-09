import 'package:lista_compras/features/shopping/data/repositories/create_shopping_list_repository.dart';
import 'package:lista_compras/features/shopping/domain/entities/create_shopping_list_entity.dart';

class CreateShoppingListUsecase {
  late final CreateShoppingListRepository repository;

  CreateShoppingListUsecase(this.repository);

  Future<CreateShoppingListEntity> createShoppingList({
    required String name,
    required String local,
    required String userId,
    String? supermarketName,
  }) {
    return repository.createShoppingList(
      name: name,
      local: local,
      userId: userId,
      supermarketName: supermarketName,
    );
  }
}
