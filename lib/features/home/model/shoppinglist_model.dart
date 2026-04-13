class ShoppinglistModel {
  final String id;
  final String name;
  final String local;
  final DateTime createdAt;

  ShoppinglistModel({
    required this.id,
    required this.name,
    required this.local,
    required this.createdAt,
  });

  factory ShoppinglistModel.fromMap(Map<String, dynamic> map) {
    return ShoppinglistModel(
      id: map['id'] as String,
      name: map['name'] as String,
      local: map['local'] as String? ?? '',
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}