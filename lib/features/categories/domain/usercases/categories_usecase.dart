import 'package:lista_compras/features/categories/data/categories_repository.dart';
import 'package:lista_compras/features/categories/domain/entity/categories_entity.dart';

class CategoriesUsecase {
  late final CategoriesRepository repository;

  CategoriesUsecase(this.repository);

  Future<List<CategoriesEntity>> fetchCategories() {
    return repository.listCategories();
  }
}