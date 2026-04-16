import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CreateShoppinglistEvent {}

// ─────────────────────────────────────────────
// Eventos da Lista de Compras
// ─────────────────────────────────────────────

class FetchShoppingListsRequested extends CreateShoppinglistEvent {}

class FetchShoppingListDetailsRequested extends CreateShoppinglistEvent {
  final String shoppingListId;

  FetchShoppingListDetailsRequested(this.shoppingListId);
}

class CreateShoppingListRequested extends CreateShoppinglistEvent {
  final String name;
  final String userId;
  final String local;
  final String? supermarketName;
  final DateTime createdAt = DateTime.now();

  CreateShoppingListRequested({
    required this.name,
    required this.userId,
    required this.local,
    this.supermarketName,
  });
}

class DeleteShoppingListRequested extends CreateShoppinglistEvent {
  final String shoppingListId;

  DeleteShoppingListRequested(this.shoppingListId);
}
