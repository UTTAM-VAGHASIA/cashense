import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashense/viewmodels/providers.dart';
import 'package:cashense/views/features/settings/pages/settings_page.dart';

void main() {
  group('Providers Integration Test', () {
    testWidgets('Settings page should load and display settings', (
      WidgetTester tester,
    ) async {
      // Set up mock SharedPreferences with some initial data
      SharedPreferences.setMockInitialValues({
        'app_settings':
            '{"crashlyticsEnabled":true,"analyticsEnabled":false,"themeMode":"system","debugMode":false}',
      });
      final mockPrefs = await SharedPreferences.getInstance();

      // Build the settings page with ProviderScope
      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(mockPrefs)],
          child: const MaterialApp(home: SettingsPage()),
        ),
      );

      // Wait for the settings to load
      await tester.pumpAndSettle();

      // Verify that the settings page loads
      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // Verify that settings content is displayed (should not show loading indicator)
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Theme mode provider should work correctly', (
      WidgetTester tester,
    ) async {
      late ThemeMode currentTheme;

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, child) {
              currentTheme = ref.watch(themeModeProvider);
              return MaterialApp(
                themeMode: currentTheme,
                home: Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      ref.read(themeModeProvider.notifier).toggleTheme();
                    },
                    child: Text('Current theme: ${currentTheme.name}'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Initial theme should be system
      expect(currentTheme, ThemeMode.system);
      expect(find.text('Current theme: system'), findsOneWidget);

      // Tap the button to toggle theme
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Theme should now be light
      expect(currentTheme, ThemeMode.light);
      expect(find.text('Current theme: light'), findsOneWidget);

      // Tap again to toggle to dark
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Theme should now be dark
      expect(currentTheme, ThemeMode.dark);
      expect(find.text('Current theme: dark'), findsOneWidget);
    });
  });
}
