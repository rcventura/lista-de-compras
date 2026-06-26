import 'package:lista_compras/features/categories/domain/entity/categories_entity.dart';
import 'package:lista_compras/features/categories/model/categories_modal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriesRepository {
  final SupabaseClient client;
  CategoriesRepository(this.client);

  // LIST CATEGORIES
  Future<List<CategoriesEntity>> listCategories() async {
    final response = await client
        .from('categories')
        .select('id, name, icon, position')
        .order('position', ascending: true);

    return (response as List)
        .map((item) => CategoriesModal.fromMap(item).toEntity())
        .toList();
  }
}
