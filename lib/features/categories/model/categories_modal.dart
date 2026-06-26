import 'package:lista_compras/features/categories/domain/entity/categories_entity.dart';

class CategoriesModal {
  final String id;
  final String name;
  final String icon;
  final int position;

  CategoriesModal({
    required this.id,
    required this.name,
    required this.icon,
    required this.position,
  });

  factory CategoriesModal.fromMap(Map<String, dynamic> map) {
    return CategoriesModal(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: map['icon'] as String,
      position: map['position'] as int,
    );
  }

  CategoriesEntity toEntity() {
    return CategoriesEntity(
      id: id,
      name: name,
      icon: icon,
      position: position,
    );
  }
}
