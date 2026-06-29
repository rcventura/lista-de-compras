abstract class CategoriesItemsEvent {}

class CategoriesItemsFetchRequest extends CategoriesItemsEvent {
  final String categoryId;
  CategoriesItemsFetchRequest({required this.categoryId});
}

class CategoriesItemsSelected extends CategoriesItemsEvent {
  final int itemIndex;
  CategoriesItemsSelected(this.itemIndex);
}