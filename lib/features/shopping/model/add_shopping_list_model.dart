class AddShoppingListModel {
  final String id;
  final String name;
  final String local;
  final String? supermarketName;
  final DateTime createdAt;

  AddShoppingListModel({
    required this.id,
    required this.name,
    required this.local,
    required this.supermarketName,
    required this.createdAt,
  });
}