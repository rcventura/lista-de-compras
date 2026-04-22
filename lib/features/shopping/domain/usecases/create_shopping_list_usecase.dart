import 'package:lista_compras/features/shopping/data/repositories/create_shopping_list_repository.dart';

class CreateShoppingListUsecase {
  late final CreateShoppingListRepository repository;

  CreateShoppingListUsecase(this.repository);

  Future<void> createShoppingList({
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
