import 'package:flutter_test/flutter_test.dart';

import 'package:lista_compras/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ListaComprasApp());
    expect(find.byType(ListaComprasApp), findsOneWidget);
  });
}
