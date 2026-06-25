import 'package:flutter_test/flutter_test.dart';
import 'package:lista_compras/core/config/supabase_config.dart';

void main() {
  test('supabase config has fallback values for URL and publishable key', () {
    expect(SupabaseConfig.url, startsWith('https://'));
    expect(SupabaseConfig.url, contains('.supabase.co'));
    expect(SupabaseConfig.publishableKey, startsWith('sb_publishable_'));
  });
}
