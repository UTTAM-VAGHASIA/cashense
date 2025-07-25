import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import the providers barrel file
import 'package:cashense/viewmodels/providers.dart';

void main() {
  group('Providers Export Test', () {
    test('should export all required providers', () {
      // Test that all providers are accessible from the barrel file

      // Settings providers
      expect(settingsViewModelProvider, isNotNull);
      expect(sharedPreferencesProvider, isNotNull);

      // App-level providers
      expect(themeModeProvider, isNotNull);
      expect(appRouterProvider, isNotNull);
    });

    test('should allow provider overrides for testing', () async {
      // Test that providers can be overridden for testing
      SharedPreferences.setMockInitialValues({});
      final mockPrefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(mockPrefs)],
      );

      // Verify that the settings provider can be accessed without throwing
      expect(
        () => container.read(settingsViewModelProvider.notifier),
        returnsNormally,
      );

      // Wait a moment before disposing to avoid race conditions
      await Future<void>.delayed(const Duration(milliseconds: 50));

      container.dispose();
    });
  });
}
