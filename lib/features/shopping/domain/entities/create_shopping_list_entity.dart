class CreateShoppingListEntity {
  final String id;
  final String name;
  final String local;
  final String? supermarketName;
  final String createdAt;

  const CreateShoppingListEntity({
    required this.id,
    required this.name,
    required this.local,
    this.supermarketName,
    required this.createdAt,
  });
}