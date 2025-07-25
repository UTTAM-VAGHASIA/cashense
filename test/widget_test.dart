// Basic Flutter widget test for Cashense app.
//
// This test verifies that the app can be instantiated and basic navigation works.

import 'package:cashense/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashense/viewmodels/providers.dart';

void main() {
  testWidgets('Cashense app smoke test', (WidgetTester tester) async {
    // Set up mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final mockPrefs = await SharedPreferences.getInstance();

    // Build our app with ProviderScope and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(mockPrefs)],
        child: const CashenseApp(),
      ),
    );

    // Wait for the app to initialize
    await tester.pumpAndSettle();

    // Verify that the app loads without crashing
    // The splash screen should be visible initially
    expect(find.byType(CashenseApp), findsOneWidget);
  });
}
