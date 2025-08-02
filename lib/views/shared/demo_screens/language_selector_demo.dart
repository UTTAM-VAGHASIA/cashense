import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/language_selector.dart';
import '../../../viewmodels/providers.dart';

/// Demo screen showcasing language selection components
class LanguageSelectorDemoScreen extends ConsumerWidget {
  const LanguageSelectorDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentLocale = ref.watch(localeProvider);
    final isRTL = ref.watch(isRTLProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Selector Demo'),
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
                'Language Selection Components',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Test different language selection components and see how they affect the app localization.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),

              // Current Language Info
              _buildInfoCard(
                context,
                title: 'Current Language Settings',
                children: [
                  _buildInfoRow('Language Code', currentLocale.languageCode),
                  _buildInfoRow('Country Code', currentLocale.countryCode ?? 'N/A'),
                  _buildInfoRow('Text Direction', isRTL ? 'RTL' : 'LTR'),
                  _buildInfoRow('Locale String', currentLocale.toString()),
                ],
              ),

              const SizedBox(height: 24),

              // Language Selector (Popup Menu)
              _buildDemoSection(
                context,
                title: 'Language Selector (Popup Menu)',
                description: 'Compact language selector with popup menu',
                child: const Row(
                  children: [
                    LanguageSelector(),
                    SizedBox(width: 16),
                    Text('Select language from dropdown'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Language Selector Tile
              _buildDemoSection(
                context,
                title: 'Language Selector Tile',
                description: 'Settings-style tile for language selection',
                child: const LanguageSelectorTile(),
              ),

              const SizedBox(height: 24),

              // Language Selector Dialog
              _buildDemoSection(
                context,
                title: 'Language Selector Dialog',
                description: 'Full-screen dialog with detailed language options',
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => const LanguageSelectorDialog(),
                    );
                  },
                  icon: const Icon(Icons.language),
                  label: const Text('Open Language Dialog'),
                ),
              ),

              const SizedBox(height: 32),

              // Localization Examples
              Text(
                'Localization Examples',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildLocalizationExamples(context),

              const SizedBox(height: 24),

              // RTL Layout Demo
              if (isRTL) ...[
                Text(
                  'RTL Layout Demo',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildRTLDemo(context),
              ],
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

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalizationExamples(BuildContext context) {
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
            'Common UI Elements',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          // Sample buttons with localized text
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save'), // This would be localized
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Cancel'), // This would be localized
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Learn More'), // This would be localized
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Sample form elements
          const TextField(
            decoration: InputDecoration(
              labelText: 'Email Address', // This would be localized
              hintText: 'Enter your email', // This would be localized
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Note: In a fully localized app, all text would change based on the selected language.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRTLDemo(BuildContext context) {
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
            'RTL Layout Elements',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          // RTL list items
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User Profile'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Notice how icons and arrows automatically flip for RTL languages.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}