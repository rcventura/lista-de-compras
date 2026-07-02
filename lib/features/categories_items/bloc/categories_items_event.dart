abstract class CategoriesItemsEvent {}

class CategoriesItemsFetchRequest extends CategoriesItemsEvent {
  final String categoryId;
  CategoriesItemsFetchRequest({required this.categoryId});
}

class CategoriesItemsAddRequest extends CategoriesItemsEvent {
  final String categoryId;
  final List<String> itemsSelected;

  CategoriesItemsAddRequest({
    required this.categoryId,
    required this.itemsSelected,
  });
}
