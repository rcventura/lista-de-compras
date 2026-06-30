abstract class CategoriesItemsEvent {}

class CategoriesItemsFetchRequest extends CategoriesItemsEvent {
  final String categoryId;
  CategoriesItemsFetchRequest({required this.categoryId});
}
