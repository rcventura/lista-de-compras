import 'package:lista_compras/features/home/data/repositories/home_respository.dart';

class DeleteShoppingListUsecase {
  final HomeRespository repository;

  DeleteShoppingListUsecase(this.repository);

  Future<void> call(String listID) {
    return repository.deleteShoppingList(listID);
  }
}
