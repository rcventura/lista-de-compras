import 'package:lista_compras/features/categories/domain/entity/categories_entity.dart';

abstract class CategoriesState {}

class CategoryInitial extends CategoriesState {}

class CategoryLoading extends CategoriesState {}

class CategoryLoadingSuccess extends CategoriesState {
  final List<CategoriesEntity> categoriesList;
  CategoryLoadingSuccess(this.categoriesList);
}

class CategoryLoadingError extends CategoriesState {
  final String message;

  CategoryLoadingError(this.message);
}