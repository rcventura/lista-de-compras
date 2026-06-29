import 'package:lista_compras/features/categories_items/domain/entity/categories_item_entity.dart';

abstract class CategoriesItemsState {}

class CategoriesItemsInitial extends CategoriesItemsState {}

class CategoriesItemsLoading extends CategoriesItemsState {}

class CategoriesItemsLoadingSuccess extends CategoriesItemsState {
  final List<CategoriesItemEntity> categoriesItemsList;
  final int? selectedIndex;

  CategoriesItemsLoadingSuccess(
    this.categoriesItemsList, {
    this.selectedIndex,
  });
}

class CategoriesItemsLoadingError extends CategoriesItemsState {
  final String message;

  CategoriesItemsLoadingError(this.message);
}
