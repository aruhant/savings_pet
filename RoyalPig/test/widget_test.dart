import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goals/main.dart';

void main() {
  testWidgets('App builds and shows Home', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Verify that the "HOME" title is present
    expect(find.text('HOME'), findsOneWidget);
  });
}
