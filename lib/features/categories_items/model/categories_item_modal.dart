import 'package:lista_compras/features/categories_items/domain/entity/categories_item_entity.dart';

class CategoriesItemModal {
  final String id;
  final String categoryId;
  final String name;
  final String defaultUnit;
  final int position;

  CategoriesItemModal({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.defaultUnit,
    required this.position,
  });

  factory CategoriesItemModal.fromMap(Map<String, dynamic> map) {
    return CategoriesItemModal(
      id: map['id'] as String,
      categoryId: map['category_id'] as String,
      name: map['name'] as String,
      defaultUnit: map['default_unit'] as String,
      position: map['position'] as int,
    );
  }
  
  CategoriesItemEntity toEntity() {
    return CategoriesItemEntity(
      id: id,
      categoryId: categoryId,
      name: name,
      defaultUnit: defaultUnit,
      position: position,
    );
  }
}
