import 'package:lista_compras/features/home/data/repositories/home_respository.dart';
import 'package:lista_compras/features/home/domain/entities/home_entity.dart';

class FilterShoppingListUsecase {
  late final HomeRespository repository;

  FilterShoppingListUsecase(this.repository);

  Future<List<HomeEntity>> filterShoppingList(
    DateTime startDate,
    DateTime endDate,
  ) {
    return repository.filterShoppingList(startDate, endDate);
  }

  Future<List<HomeEntity>> searchShoppingList(
    DateTime startDate,
    DateTime endDate,
  ) {
    return repository.filterShoppingList(startDate, endDate);
  }
}
