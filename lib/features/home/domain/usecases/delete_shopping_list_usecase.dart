import 'package:lista_compras/features/home/data/repositories/home_respository.dart';
import 'package:lista_compras/features/home/domain/entities/home_entity.dart';

class DeleteShoppingListUsecase {
  late final HomeRespository repository;

  DeleteShoppingListUsecase(this.repository);

  Future<List<HomeEntity>> deleteShoppingList(String listID) {
    return repository.deleteShoppingList(listID);
  }
}
