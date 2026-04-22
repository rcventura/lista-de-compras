abstract class CreateShoppinglistEvent {}

class CreateShoppingListRequested extends CreateShoppinglistEvent {
  final String? id;
  final String name;
  final String userId;
  final String local;
  final String? supermarketName;
  final DateTime createdAt = DateTime.now();

  CreateShoppingListRequested({
    this.id,
    required this.name,
    required this.userId,
    required this.local,
    this.supermarketName,
  });
}
