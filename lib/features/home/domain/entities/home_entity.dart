class HomeEntity {
  final String id;
  final String name;
  final String local;
  final String? supermarketName;
  final DateTime createdAt;

  const HomeEntity({
    required this.id,
    required this.name,
    required this.local,
    this.supermarketName,
    required this.createdAt,
  });
}
