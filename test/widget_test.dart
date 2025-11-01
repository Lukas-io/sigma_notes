// This is a basic Flutter widget test for Sigma Notes.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_notes/core/router/router.dart';

import 'package:sigma_notes/main.dart';

void main() {
  testWidgets('App loads without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProviderScope(child: SigmaNotes()));

    // Pump for enough time to pass the splash screen delay
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify that the app loads without throwing errors
    expect(tester.takeException(), isNull);
  });
}
