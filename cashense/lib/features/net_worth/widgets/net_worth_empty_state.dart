import 'package:flutter/material.dart';

import 'package:cashense/utils/constants/sizes.dart';

/// Empty state for the Net Worth dashboard.
///
/// Empty states are real screens with the next-action CTA (PROJECT.md §8):
/// net worth is ₹0, so the single primary action is adding the first asset.
class NetWorthEmptyState extends StatelessWidget {
  const NetWorthEmptyState({super.key, required this.onAddAsset});

  /// Invoked when the user taps the primary "Add your first asset" CTA.
  final VoidCallback onAddAsset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
          ),
          child: Icon(
            Icons.account_balance_wallet_outlined,
            size: AppSizes.iconLg,
            color: scheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: AppSizes.lg),
        Text(
          'Start tracking your wealth',
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          'Add what you own and owe to see your net worth in one calm screen.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSizes.xl),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onAddAsset,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add your first asset'),
          ),
        ),
      ],
    );
  }
}
