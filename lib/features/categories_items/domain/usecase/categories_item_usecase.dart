import 'package:lista_compras/features/categories_items/data/categories_item_repository.dart';
import 'package:lista_compras/features/categories_items/domain/entity/categories_item_entity.dart';

class CategoriesItemsUsecase {
  late final CategoryItemRepository repository;

  CategoriesItemsUsecase(this.repository);

  Future<List<CategoriesItemEntity>> fetchCategoriesItems(String categoryId) {
    return repository.listCategoriesItems(categoryId);
  }
}