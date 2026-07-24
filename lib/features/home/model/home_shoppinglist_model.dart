import 'package:lista_compras/features/home/domain/entities/home_entity.dart';

class HomeShoppinglistModel {
  final String id;
  final String name;
  final String local;
  final DateTime createdAt;
  final int itemsCount;

  HomeShoppinglistModel({
    required this.id,
    required this.name,
    required this.local,
    required this.createdAt,
    required this.itemsCount,
  });

  factory HomeShoppinglistModel.fromMap(Map<String, dynamic> map) {
    final items = map['shopping_list_items'];
    final itemsCount = map['items_count'];

    return HomeShoppinglistModel(
      id: map['id'] as String,
      name: map['name'] as String,
      local: map['local'] as String? ?? '',
      createdAt: DateTime.parse(
        map['created_at'] as String,
      ).toUtc().subtract(const Duration(hours: 3)),
      itemsCount: itemsCount is int
          ? itemsCount
          : items is List
          ? items.length
          : 0,
    );
  }

  HomeEntity toEntity() {
    return HomeEntity(
      id: id,
      name: name,
      local: local,
      createdAt: createdAt,
      itemsCount: itemsCount,
    );
  }
}
