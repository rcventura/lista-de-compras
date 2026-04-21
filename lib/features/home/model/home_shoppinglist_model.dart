import 'package:lista_compras/features/home/domain/entities/home_entity.dart';

class HomeShoppinglistModel {
  final String id;
  final String name;
  final String local;
  final DateTime createdAt;

  HomeShoppinglistModel({
    required this.id,
    required this.name,
    required this.local,
    required this.createdAt,
  });

  factory HomeShoppinglistModel.fromMap(Map<String, dynamic> map) {
    return HomeShoppinglistModel(
      id: map['id'] as String,
      name: map['name'] as String,
      local: map['local'] as String? ?? '',
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  HomeEntity toEntity() {
    return HomeEntity(id: id, name: name, local: local, createdAt: createdAt);
  }
}
