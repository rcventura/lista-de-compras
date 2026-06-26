abstract class CategoriesEvent {}

class CategoriesFetchItemRequest extends CategoriesEvent {}

class CategoriesItemSelected extends CategoriesEvent {
  final String categoryId;
  CategoriesItemSelected(this.categoryId);
}