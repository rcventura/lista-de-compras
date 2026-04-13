import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ShoppingListEvent {}

// ─────────────────────────────────────────────
// Eventos da Lista de Compras
// ─────────────────────────────────────────────

class FetchShoppingListsRequested extends ShoppingListEvent {}

class FetchShoppingListDetailsRequested extends ShoppingListEvent {
  final String shoppingListId;

  FetchShoppingListDetailsRequested(this.shoppingListId);
}

class CreateShoppingListRequested extends ShoppingListEvent {
  final String name;
  final String userId = Supabase.instance.client.auth.currentUser?.id ?? '';
  final String location;
  final String? supermarketName;
  final DateTime createdAt = DateTime.now();

  CreateShoppingListRequested({
    required this.name,
    required this.location,
    this.supermarketName,
  });
}

class DeleteShoppingListRequested extends ShoppingListEvent {
  final String shoppingListId;

  DeleteShoppingListRequested(this.shoppingListId);
}
