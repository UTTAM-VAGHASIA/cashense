import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/theme_config.dart';
import '../../app/theme/theme_service.dart';
import '../../app/theme/responsive_theme.dart';

/// Theme switcher widget for quick theme mode changes
class ThemeSwitcher extends ConsumerWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeConfigProvider);

    return ResponsiveBuilder(
      mobile: _buildMobileThemeSwitcher(context, ref, themeConfig),
      tablet: _buildTabletThemeSwitcher(context, ref, themeConfig),
      desktop: _buildDesktopThemeSwitcher(context, ref, themeConfig),
    );
  }

  Widget _buildMobileThemeSwitcher(
    BuildContext context,
    WidgetRef ref,
    ThemeConfig themeConfig,
  ) {
    return PopupMenuButton<ThemeMode>(
      icon: Icon(_getThemeIcon(themeConfig.themeMode)),
      tooltip: 'Change theme',
      onSelected: (ThemeMode mode) {
        ref.read(themeConfigProvider.notifier).updateThemeMode(mode);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemeMode.light,
          child: ListTile(
            leading: const Icon(Icons.light_mode),
            title: const Text('Light'),
            trailing: themeConfig.themeMode == ThemeMode.light
                ? const Icon(Icons.check)
                : null,
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark'),
            trailing: themeConfig.themeMode == ThemeMode.dark
                ? const Icon(Icons.check)
                : null,
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.system,
          child: ListTile(
            leading: const Icon(Icons.auto_mode),
            title: const Text('System'),
            trailing: themeConfig.themeMode == ThemeMode.system
                ? const Icon(Icons.check)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTabletThemeSwitcher(
    BuildContext context,
    WidgetRef ref,
    ThemeConfig themeConfig,
  ) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(
          value: ThemeMode.light,
          icon: Icon(Icons.light_mode),
          label: Text('Light'),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          icon: Icon(Icons.dark_mode),
          label: Text('Dark'),
        ),
        ButtonSegment(
          value: ThemeMode.system,
          icon: Icon(Icons.auto_mode),
          label: Text('System'),
        ),
      ],
      selected: {themeConfig.themeMode},
      onSelectionChanged: (Set<ThemeMode> selection) {
        if (selection.isNotEmpty) {
          ref
              .read(themeConfigProvider.notifier)
              .updateThemeMode(selection.first);
        }
      },
    );
  }

  Widget _buildDesktopThemeSwitcher(
    BuildContext context,
    WidgetRef ref,
    ThemeConfig themeConfig,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.light_mode),
          tooltip: 'Light theme',
          isSelected: themeConfig.themeMode == ThemeMode.light,
          onPressed: () {
            ref
                .read(themeConfigProvider.notifier)
                .updateThemeMode(ThemeMode.light);
          },
        ),
        IconButton(
          icon: const Icon(Icons.dark_mode),
          tooltip: 'Dark theme',
          isSelected: themeConfig.themeMode == ThemeMode.dark,
          onPressed: () {
            ref
                .read(themeConfigProvider.notifier)
                .updateThemeMode(ThemeMode.dark);
          },
        ),
        IconButton(
          icon: const Icon(Icons.auto_mode),
          tooltip: 'System theme',
          isSelected: themeConfig.themeMode == ThemeMode.system,
          onPressed: () {
            ref
                .read(themeConfigProvider.notifier)
                .updateThemeMode(ThemeMode.system);
          },
        ),
      ],
    );
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.auto_mode;
    }
  }
}

/// Advanced theme settings dialog
class ThemeSettingsDialog extends ConsumerWidget {
  const ThemeSettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeConfigProvider);

    return Dialog(
      child: Container(
        width: context.responsiveDialogWidth,
        padding: context.responsivePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Settings',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Theme Mode
            _buildThemeModeSection(context, ref, themeConfig),
            const SizedBox(height: 16),

            // Dynamic Colors
            _buildDynamicColorsSection(context, ref, themeConfig),
            const SizedBox(height: 16),

            // Font Scale
            _buildFontScaleSection(context, ref, themeConfig),
            const SizedBox(height: 16),

            // Color Variant
            _buildColorVariantSection(context, ref, themeConfig),
            const SizedBox(height: 16),

            // Accessibility
            _buildAccessibilitySection(context, ref, themeConfig),
            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeModeSection(
    BuildContext context,
    WidgetRef ref,
    ThemeConfig themeConfig,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Theme Mode', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(
              value: ThemeMode.light,
              icon: Icon(Icons.light_mode),
              label: Text('Light'),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              icon: Icon(Icons.dark_mode),
              label: Text('Dark'),
            ),
            ButtonSegment(
              value: ThemeMode.system,
              icon: Icon(Icons.auto_mode),
              label: Text('System'),
            ),
          ],
          selected: {themeConfig.themeMode},
          onSelectionChanged: (Set<ThemeMode> selection) {
            if (selection.isNotEmpty) {
              ref
                  .read(themeConfigProvider.notifier)
                  .updateThemeMode(selection.first);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDynamicColorsSection(
    BuildContext context,
    WidgetRef ref,
    ThemeConfig themeConfig,
  ) {
    return SwitchListTile(
      title: const Text('Dynamic Colors'),
      subtitle: const Text('Use system colors when available'),
      value: themeConfig.useDynamicColors,
      onChanged: (value) {
        ref.read(themeConfigProvider.notifier).updateUseDynamicColors(value);
      },
    );
  }

  Widget _buildFontScaleSection(
    BuildContext context,
    WidgetRef ref,
    ThemeConfig themeConfig,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Font Size', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Slider(
          value: themeConfig.fontScale,
          min: 0.8,
          max: 2.0,
          divisions: 12,
          label: '${(themeConfig.fontScale * 100).round()}%',
          onChanged: (value) {
            ref.read(themeConfigProvider.notifier).updateFontScale(value);
          },
        ),
        Text(
          'Current: ${(themeConfig.fontScale * 100).round()}%',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildColorVariantSection(
    BuildContext context,
    WidgetRef ref,
    ThemeConfig themeConfig,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color Variant', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ColorVariant.values.map((variant) {
            return ChoiceChip(
              label: Text(_getColorVariantName(variant)),
              selected: themeConfig.colorVariant == variant,
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(themeConfigProvider.notifier)
                      .updateColorVariant(variant);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAccessibilitySection(
    BuildContext context,
    WidgetRef ref,
    ThemeConfig themeConfig,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Accessibility', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('High Contrast'),
          subtitle: const Text('Increase color contrast for better visibility'),
          value: themeConfig.useHighContrast,
          onChanged: (value) {
            ref.read(themeConfigProvider.notifier).updateUseHighContrast(value);
          },
        ),
        SwitchListTile(
          title: const Text('Reduced Motion'),
          subtitle: const Text('Minimize animations and transitions'),
          value: themeConfig.reducedMotion,
          onChanged: (value) {
            ref.read(themeConfigProvider.notifier).updateReducedMotion(value);
          },
        ),
      ],
    );
  }

  String _getColorVariantName(ColorVariant variant) {
    switch (variant) {
      case ColorVariant.defaultVariant:
        return 'Default';
      case ColorVariant.vibrant:
        return 'Vibrant';
      case ColorVariant.monochrome:
        return 'Monochrome';
      case ColorVariant.highContrast:
        return 'High Contrast';
      case ColorVariant.custom:
        return 'Custom';
    }
  }
}

/// Quick theme toggle button
class QuickThemeToggle extends ConsumerWidget {
  const QuickThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeConfigProvider);

    return IconButton(
      icon: Icon(_getThemeIcon(themeConfig.themeMode)),
      tooltip: 'Toggle theme',
      onPressed: () {
        ref.read(themeConfigProvider.notifier).toggleThemeMode();
      },
    );
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.auto_mode;
    }
  }
}
