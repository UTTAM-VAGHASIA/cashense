import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/index.dart';
import '../../../../utils/formatters.dart';
import '../../../shared/widgets/language_selector.dart';

/// A demo page showcasing localization features
class LocalizationDemoPage extends ConsumerWidget {
  const LocalizationDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isRTL = ref.watch(isRTLProvider);

    return Directionality(
      textDirection: context.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.language),
          actions: const [LanguageSelector()],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language Information Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Language Information',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(
                        label: 'Language Code',
                        value: currentLocale.languageCode,
                      ),
                      _InfoRow(
                        label: 'Country Code',
                        value: currentLocale.countryCode ?? 'N/A',
                      ),
                      _InfoRow(
                        label: 'Display Name',
                        value: LocalizationService.getLanguageDisplayName(
                          currentLocale.languageCode,
                        ),
                      ),
                      _InfoRow(
                        label: 'Text Direction',
                        value: isRTL
                            ? 'RTL (Right-to-Left)'
                            : 'LTR (Left-to-Right)',
                      ),
                      _InfoRow(
                        label: 'First Day of Week',
                        value: context.firstDayOfWeek == 0
                            ? 'Sunday'
                            : 'Monday',
                      ),
                      _InfoRow(
                        label: '24-Hour Format',
                        value: context.uses24HourFormat ? 'Yes' : 'No',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Localized Strings Demo
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Localized Strings Demo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      _localizedStringDemo(context),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Number and Currency Formatting Demo
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Number & Currency Formatting',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      _numberFormattingDemo(context),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Date and Time Formatting Demo
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date & Time Formatting',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      _dateTimeFormattingDemo(context),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Pluralization Demo
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pluralization Demo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      _pluralizationDemo(context),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // RTL Layout Demo
              if (isRTL)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RTL Layout Demo',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        _rtlLayoutDemo(context),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // Language Selector Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => LanguageSelectorDialog.show(context),
                  icon: const Icon(Icons.language),
                  label: Text('Change ${context.l10n.language}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _localizedStringDemo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DemoRow(label: 'Welcome Message', value: context.l10n.welcome),
        _DemoRow(label: 'App Tagline', value: context.l10n.tagline),
        _DemoRow(label: 'Sign In', value: context.l10n.signIn),
        _DemoRow(label: 'Dashboard', value: context.l10n.dashboard),
        _DemoRow(label: 'Settings', value: context.l10n.settings),
        _DemoRow(
          label: 'Welcome User',
          value: context.l10n.welcomeUser('John Doe'),
        ),
      ],
    );
  }

  Widget _numberFormattingDemo(BuildContext context) {
    const amount = 1234567.89;
    const percentage = 15.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DemoRow(label: 'Number', value: context.formatNumber(amount)),
        _DemoRow(
          label: 'USD Currency',
          value: context.formatCurrency(amount, 'USD'),
        ),
        _DemoRow(
          label: 'EUR Currency',
          value: context.formatCurrency(amount, 'EUR'),
        ),
        _DemoRow(
          label: 'Local Currency (INR)',
          value: context.formatCurrency(amount, 'INR'),
        ),
        _DemoRow(
          label: 'Percentage',
          value: context.formatPercentage(percentage),
        ),
        _DemoRow(
          label: 'Compact Currency',
          value: Formatters.formatCurrencyAdvanced(
            amount: amount,
            currencyCode: 'USD',
            locale: context.locale,
            compact: true,
          ),
        ),
      ],
    );
  }

  Widget _dateTimeFormattingDemo(BuildContext context) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final lastWeek = now.subtract(const Duration(days: 7));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DemoRow(label: 'Today', value: context.formatDate(now)),
        _DemoRow(label: 'Date & Time', value: context.formatDateTime(now)),
        _DemoRow(label: 'Time Only', value: context.formatTime(now)),
        _DemoRow(label: 'Short Date', value: context.formatDateShort(now)),
        _DemoRow(label: 'Long Date', value: context.formatDateLong(now)),
        _DemoRow(
          label: 'Relative Time (Yesterday)',
          value: context.formatRelativeTime(yesterday),
        ),
        _DemoRow(
          label: 'Relative Time (Last Week)',
          value: context.formatRelativeTime(lastWeek),
        ),
      ],
    );
  }

  Widget _pluralizationDemo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DemoRow(
          label: '0 Transactions',
          value: context.l10n.transactionCount(0),
        ),
        _DemoRow(
          label: '1 Transaction',
          value: context.l10n.transactionCount(1),
        ),
        _DemoRow(
          label: '5 Transactions',
          value: context.l10n.transactionCount(5),
        ),
        _DemoRow(
          label: '100 Transactions',
          value: context.l10n.transactionCount(100),
        ),
      ],
    );
  }

  Widget _rtlLayoutDemo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('This section demonstrates RTL layout:'),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.arrow_forward),
            const SizedBox(width: 8),
            Text(context.l10n.next),
            const Spacer(),
            Text(context.l10n.previous),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_back),
          ],
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.account_balance_wallet),
          title: Text(context.l10n.accounts),
          subtitle: Text(context.l10n.accountBalance('\$1,234.56')),
          trailing: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _DemoRow extends StatelessWidget {
  const _DemoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
