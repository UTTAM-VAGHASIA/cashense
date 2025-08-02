import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme_switcher.dart';

/// Demo screen showcasing theme switching components
class ThemeSwitcherDemoScreen extends ConsumerWidget {
  const ThemeSwitcherDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Switcher Demo'),
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Theme Controls',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Test different theme switching components and see how they affect the app appearance.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),

              // Quick Theme Toggle
              _buildDemoSection(
                context,
                title: 'Quick Theme Toggle',
                description: 'Simple button to toggle between light and dark themes',
                child: const Row(
                  children: [
                    QuickThemeToggle(),
                    SizedBox(width: 16),
                    Text('Tap to toggle theme'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Theme Switcher Widget
              _buildDemoSection(
                context,
                title: 'Theme Switcher',
                description: 'Comprehensive theme selection with multiple options',
                child: const ThemeSwitcher(),
              ),

              const SizedBox(height: 24),

              // Advanced Theme Settings
              _buildDemoSection(
                context,
                title: 'Advanced Theme Settings',
                description: 'Open the full theme settings dialog',
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => const ThemeSettingsDialog(),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Open Theme Settings'),
                ),
              ),

              const SizedBox(height: 32),

              // Color Showcase
              Text(
                'Current Theme Colors',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildColorShowcase(context),

              const SizedBox(height: 32),

              // Typography Showcase
              Text(
                'Typography Styles',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTypographyShowcase(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoSection(
    BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildColorShowcase(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final colors = [
      ('Primary', colorScheme.primary),
      ('Secondary', colorScheme.secondary),
      ('Tertiary', colorScheme.tertiary),
      ('Surface', colorScheme.surface),
      ('Error', colorScheme.error),
      ('Outline', colorScheme.outline),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((colorInfo) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colorInfo.$2,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Center(
            child: Text(
              colorInfo.$1,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorInfo.$2.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTypographyShowcase(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Large', style: theme.textTheme.displayLarge),
        const SizedBox(height: 8),
        Text('Headline Medium', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text('Title Large', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('Body Large', style: theme.textTheme.bodyLarge),
        const SizedBox(height: 8),
        Text('Body Medium', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        Text('Label Small', style: theme.textTheme.labelSmall),
      ],
    );
  }
}