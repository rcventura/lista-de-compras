import 'package:lista_compras/features/shopping/domain/entities/create_shopping_list_entity.dart';

class CreateShoppingListModel {
  final String id;
  final String name;
  final String local;
  final String? supermarketName;
  final DateTime createdAt;

  CreateShoppingListModel({
    required this.id,
    required this.name,
    required this.local,
    this.supermarketName,
    required this.createdAt,
  });

  factory CreateShoppingListModel.fromMap(Map<String, dynamic> map) {
    return CreateShoppingListModel(
      id: map['id'] as String,
      name: map['name'] as String,
      local: map['local'] as String? ?? '',
      supermarketName: map['supermarket_name'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  CreateShoppingListEntity toEntity() {
    return CreateShoppingListEntity(
      id: id,
      name: name,
      local: local,
      supermarketName: supermarketName,
      createdAt: createdAt,
    );
  }
}
