import 'package:lista_compras/features/categories_items/domain/entity/categories_item_entity.dart';
import 'package:lista_compras/features/categories_items/model/categories_item_modal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryItemRepository {
  final SupabaseClient client;
  CategoryItemRepository(this.client);

  Future<List<CategoriesItemEntity>> listCategoriesItems(String categoryId) async {
    try {
      final response = await client
          .from('products')
          .select('id, category_id, default_unit, name, position')
          .eq('category_id', categoryId)
          .order('position', ascending: true);
      return response
          .map((item) => CategoriesItemModal.fromMap(item).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to load category items: $e');
    }
  }
}
