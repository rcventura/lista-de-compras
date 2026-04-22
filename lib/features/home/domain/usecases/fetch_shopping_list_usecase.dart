import 'package:lista_compras/features/home/data/repositories/home_respository.dart';
import 'package:lista_compras/features/home/domain/entities/home_entity.dart';

class FetchShoppingListUsecase {
  late final HomeRespository repository;

  FetchShoppingListUsecase(this.repository);

  Future<List<HomeEntity>> fetchShoppingList() {
    return repository.fetchShoppingList();
  }
}
