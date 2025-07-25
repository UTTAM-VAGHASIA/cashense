import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodels/providers.dart';
import '../../../../services/crashlytics_service.dart';

/// Settings page for managing app preferences
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(settingsViewModelProvider);
            },
            tooltip: 'Refresh Settings',
          ),
        ],
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading settings: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(settingsViewModelProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (settings) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Privacy & Data Section
            _buildSectionHeader('Privacy & Data'),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Crash Reporting'),
                    subtitle: const Text(
                      'Help improve the app by sending crash reports',
                    ),
                    value: settings.crashlyticsEnabled,
                    onChanged: (value) {
                      ref
                          .read(settingsViewModelProvider.notifier)
                          .toggleCrashlytics(value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Analytics'),
                    subtitle: const Text(
                      'Help improve the app by sharing usage data',
                    ),
                    value: settings.analyticsEnabled,
                    onChanged: (value) {
                      ref
                          .read(settingsViewModelProvider.notifier)
                          .toggleAnalytics(value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Appearance Section
            _buildSectionHeader('Appearance'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Theme'),
                    subtitle: Text(_getThemeDisplayName(settings.themeMode)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        _showThemeDialog(context, ref, settings.themeMode),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Debug Section
            _buildSectionHeader('Debug'),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Debug Mode'),
                    subtitle: const Text(
                      'Enable additional debugging features',
                    ),
                    value: settings.debugMode,
                    onChanged: (value) {
                      ref
                          .read(settingsViewModelProvider.notifier)
                          .toggleDebugMode(value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Debug Tools (only show in debug mode)
            if (settings.debugMode) ...[
              _buildSectionHeader('Debug Tools'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Test Crash'),
                      subtitle: const Text(
                        'Trigger a test crash for Crashlytics',
                      ),
                      trailing: const Icon(Icons.bug_report),
                      onTap: () => _showTestCrashDialog(context),
                    ),
                    ListTile(
                      title: const Text('Send Test Log'),
                      subtitle: const Text('Send a test log to Crashlytics'),
                      trailing: const Icon(Icons.send),
                      onTap: () async {
                        await CrashlyticsService.instance.log(
                          'Test log from settings page',
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Test log sent')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Reset Section
            _buildSectionHeader('Reset'),
            Card(
              child: ListTile(
                title: const Text('Reset Settings'),
                subtitle: const Text('Reset all settings to default values'),
                trailing: const Icon(Icons.restore),
                onTap: () => _showResetDialog(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  String _getThemeDisplayName(String themeMode) {
    switch (themeMode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      case 'system':
      default:
        return 'System';
    }
  }

  Future<void> _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    String currentTheme,
  ) async => await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Choose Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: const Text('Light'),
            value: 'light',
            groupValue: currentTheme,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(settingsViewModelProvider.notifier)
                    .updateThemeMode(value);
                Navigator.of(context).pop();
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('Dark'),
            value: 'dark',
            groupValue: currentTheme,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(settingsViewModelProvider.notifier)
                    .updateThemeMode(value);
                Navigator.of(context).pop();
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('System'),
            value: 'system',
            groupValue: currentTheme,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(settingsViewModelProvider.notifier)
                    .updateThemeMode(value);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    ),
  );

  Future<void> _showTestCrashDialog(
    BuildContext context,
  ) async => await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Test Crash'),
      content: const Text(
        'This will trigger a test crash to verify Crashlytics is working. '
        'The app will close and the crash will be reported to Firebase Crashlytics.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await CrashlyticsService.instance.testCrash();
          },
          child: const Text('Test Crash'),
        ),
      ],
    ),
  );

  Future<void> _showResetDialog(BuildContext context, WidgetRef ref) async =>
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reset Settings'),
          content: const Text(
            'This will reset all settings to their default values. '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(settingsViewModelProvider.notifier).resetSettings();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings reset to defaults')),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      );
}
