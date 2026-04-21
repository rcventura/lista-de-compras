import 'package:lista_compras/features/shopping/data/repositories/detail_shopping_list_repository.dart';
import 'package:lista_compras/features/shopping/domain/entities/fetch_detail_shopping_list_entity.dart';

class FetchDetailShoppingListUsecase {
  late final DetailShoppingListRepository repository;

  FetchDetailShoppingListUsecase(this.repository);

  Future<List<FetchDetailShoppingListEntity>> fetchShoppingListDetail() {
    return repository.fetchShoppingListDetail();
  }
}
