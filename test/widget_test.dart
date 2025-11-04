// This is a basic Flutter widget test for Sigma Notes.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sigma_notes/main.dart';

void main() {
  testWidgets('App loads without errors', (WidgetTester tester) async {
    print('\n=== Testing: MyApp smoke test ===');
    print('Action: pump SigmaNotes inside ProviderScope');
    await tester.pumpWidget(ProviderScope(child: SigmaNotes()));

    // Pump for enough time to pass any initial async work
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify that the app loads without throwing errors
    print('Expected: No exceptions thrown');
    expect(tester.takeException(), isNull);

    // Verify ProviderScope is present
    final providerScopeFound = find.byType(ProviderScope);
    print('Expected: ProviderScope found');
    print('Actual: found count = ${providerScopeFound.evaluate().length}');
    expect(providerScopeFound, findsOneWidget);
    print('✅ Test PASSED: App built and ProviderScope present');
  });
}
