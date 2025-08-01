import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/theme_config.dart';
import '../../../../app/theme/theme_service.dart';
import '../../../../app/theme/responsive_theme.dart';

/// Theme settings page for comprehensive theme customization
class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(themeConfigProvider);
    final themeNotifier = ref.read(themeConfigProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: context.responsivePadding,
        children: [
          // Theme Mode Section
          _buildSectionHeader(context, 'Theme Mode'),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Light'),
                  subtitle: const Text('Always use light theme'),
                  value: ThemeMode.light,
                  groupValue: themeConfig.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeNotifier.updateThemeMode(value);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark'),
                  subtitle: const Text('Always use dark theme'),
                  value: ThemeMode.dark,
                  groupValue: themeConfig.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeNotifier.updateThemeMode(value);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('System'),
                  subtitle: const Text('Follow system theme'),
                  value: ThemeMode.system,
                  groupValue: themeConfig.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeNotifier.updateThemeMode(value);
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Dynamic Colors Section
          _buildSectionHeader(context, 'Dynamic Colors'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Use Dynamic Colors'),
                  subtitle: const Text('Use colors from your wallpaper'),
                  value: themeConfig.useDynamicColors,
                  onChanged: (value) {
                    themeNotifier.updateUseDynamicColors(value);
                  },
                ),
                SwitchListTile(
                  title: const Text('High Contrast'),
                  subtitle: const Text(
                    'Increase color contrast for better accessibility',
                  ),
                  value: themeConfig.useHighContrast,
                  onChanged: (value) {
                    themeNotifier.updateUseHighContrast(value);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Color Variant Section
          _buildSectionHeader(context, 'Color Style'),
          Card(
            child: Column(
              children: ColorVariant.values.map((variant) {
                return RadioListTile<ColorVariant>(
                  title: Text(_getColorVariantName(variant)),
                  subtitle: Text(_getColorVariantDescription(variant)),
                  value: variant,
                  groupValue: themeConfig.colorVariant,
                  onChanged: (value) {
                    if (value != null) {
                      themeNotifier.updateColorVariant(value);
                    }
                  },
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Typography Section
          _buildSectionHeader(context, 'Typography'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Font Scale'),
                  subtitle: Text('${(themeConfig.fontScale * 100).round()}%'),
                  trailing: SizedBox(
                    width: 200,
                    child: Slider(
                      value: themeConfig.fontScale,
                      min: 0.8,
                      max: 2.0,
                      divisions: 12,
                      label: '${(themeConfig.fontScale * 100).round()}%',
                      onChanged: (value) {
                        themeNotifier.updateFontScale(value);
                      },
                    ),
                  ),
                ),
                const Divider(),
                ...TypographyStyle.values.map((style) {
                  return RadioListTile<TypographyStyle>(
                    title: Text(_getTypographyStyleName(style)),
                    subtitle: Text(_getTypographyStyleDescription(style)),
                    value: style,
                    groupValue: themeConfig.typographyStyle,
                    onChanged: (value) {
                      if (value != null) {
                        themeNotifier.updateTypographyStyle(value);
                      }
                    },
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Border Radius Section
          _buildSectionHeader(context, 'Border Radius'),
          Card(
            child: Column(
              children: BorderRadiusStyle.values.map((style) {
                return RadioListTile<BorderRadiusStyle>(
                  title: Text(_getBorderRadiusStyleName(style)),
                  subtitle: Text(_getBorderRadiusStyleDescription(style)),
                  value: style,
                  groupValue: themeConfig.borderRadiusStyle,
                  onChanged: (value) {
                    if (value != null) {
                      themeNotifier.updateBorderRadiusStyle(value);
                    }
                  },
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Elevation Section
          _buildSectionHeader(context, 'Elevation'),
          Card(
            child: Column(
              children: ElevationStyle.values.map((style) {
                return RadioListTile<ElevationStyle>(
                  title: Text(_getElevationStyleName(style)),
                  subtitle: Text(_getElevationStyleDescription(style)),
                  value: style,
                  groupValue: themeConfig.elevationStyle,
                  onChanged: (value) {
                    if (value != null) {
                      themeNotifier.updateElevationStyle(value);
                    }
                  },
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Accessibility Section
          _buildSectionHeader(context, 'Accessibility'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Reduced Motion'),
                  subtitle: const Text('Reduce animations and transitions'),
                  value: themeConfig.reducedMotion,
                  onChanged: (value) {
                    themeNotifier.updateReducedMotion(value);
                  },
                ),
                SwitchListTile(
                  title: const Text('Monochrome Icons'),
                  subtitle: const Text(
                    'Use single-color icons for better contrast',
                  ),
                  value: themeConfig.useMonochromeIcons,
                  onChanged: (value) {
                    themeNotifier.updateUseMonochromeIcons(value);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Preview Section
          _buildSectionHeader(context, 'Preview'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme Preview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildThemePreview(context),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Reset Section
          _buildSectionHeader(context, 'Reset'),
          Card(
            child: ListTile(
              title: const Text('Reset to Defaults'),
              subtitle: const Text(
                'Reset all theme settings to default values',
              ),
              trailing: const Icon(Icons.restore),
              onTap: () => _showResetDialog(context, themeNotifier),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildThemePreview(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Color preview
        Row(
          children: [
            _buildColorSwatch('Primary', theme.colorScheme.primary),
            const SizedBox(width: 16),
            _buildColorSwatch('Secondary', theme.colorScheme.secondary),
            const SizedBox(width: 16),
            _buildColorSwatch('Tertiary', theme.colorScheme.tertiary),
          ],
        ),
        const SizedBox(height: 16),

        // Button preview
        Row(
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
            const SizedBox(width: 8),
            FilledButton(onPressed: () {}, child: const Text('Filled')),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
          ],
        ),
        const SizedBox(height: 16),

        // Card preview
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sample Card', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'This is how cards will look with your current theme settings.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorSwatch(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
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

  String _getColorVariantDescription(ColorVariant variant) {
    switch (variant) {
      case ColorVariant.defaultVariant:
        return 'Standard color scheme';
      case ColorVariant.vibrant:
        return 'More saturated colors';
      case ColorVariant.monochrome:
        return 'Grayscale colors';
      case ColorVariant.highContrast:
        return 'Enhanced contrast';
      case ColorVariant.custom:
        return 'Custom color scheme';
    }
  }

  String _getTypographyStyleName(TypographyStyle style) {
    switch (style) {
      case TypographyStyle.compact:
        return 'Compact';
      case TypographyStyle.material3:
        return 'Material 3';
      case TypographyStyle.comfortable:
        return 'Comfortable';
      case TypographyStyle.large:
        return 'Large';
    }
  }

  String _getTypographyStyleDescription(TypographyStyle style) {
    switch (style) {
      case TypographyStyle.compact:
        return 'Smaller text sizes for more content';
      case TypographyStyle.material3:
        return 'Standard Material 3 typography';
      case TypographyStyle.comfortable:
        return 'Larger text for better readability';
      case TypographyStyle.large:
        return 'Extra large text for accessibility';
    }
  }

  String _getBorderRadiusStyleName(BorderRadiusStyle style) {
    switch (style) {
      case BorderRadiusStyle.sharp:
        return 'Sharp';
      case BorderRadiusStyle.rounded:
        return 'Rounded';
      case BorderRadiusStyle.extraRounded:
        return 'Extra Rounded';
    }
  }

  String _getBorderRadiusStyleDescription(BorderRadiusStyle style) {
    switch (style) {
      case BorderRadiusStyle.sharp:
        return 'Square corners';
      case BorderRadiusStyle.rounded:
        return 'Moderately rounded corners';
      case BorderRadiusStyle.extraRounded:
        return 'Highly rounded corners';
    }
  }

  String _getElevationStyleName(ElevationStyle style) {
    switch (style) {
      case ElevationStyle.flat:
        return 'Flat';
      case ElevationStyle.material2:
        return 'Material 2';
      case ElevationStyle.material3:
        return 'Material 3';
      case ElevationStyle.elevated:
        return 'Elevated';
    }
  }

  String _getElevationStyleDescription(ElevationStyle style) {
    switch (style) {
      case ElevationStyle.flat:
        return 'No shadows or elevation';
      case ElevationStyle.material2:
        return 'Classic Material Design shadows';
      case ElevationStyle.material3:
        return 'Modern Material 3 elevation';
      case ElevationStyle.elevated:
        return 'Enhanced elevation and shadows';
    }
  }

  Future<void> _showResetDialog(
    BuildContext context,
    ThemeNotifier themeNotifier,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Theme Settings'),
        content: const Text(
          'This will reset all theme settings to their default values. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              themeNotifier.resetToDefaults();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Theme settings reset to defaults'),
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
