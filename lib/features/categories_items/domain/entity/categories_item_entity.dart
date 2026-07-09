class CategoriesItemEntity {
  final String id;
  final String categoryId;
  final String name;
  final String defaultUnit;
  final int position;

  const CategoriesItemEntity({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.defaultUnit,
    required this.position,
  });
}
