import 'package:flutter/material.dart';

import 'package:cashense/utils/constants/colors.dart';
import 'package:cashense/utils/constants/sizes.dart';
import 'package:cashense/utils/formatters/currency_formatter.dart';

/// The hero header for the Net Worth dashboard — the amount is the hero
/// (PROJECT.md §8). Renders `netWorth` large, with the assets/liabilities
/// breakdown beneath. Colour follows the money rule: positive green,
/// negative red, zero neutral.
class NetWorthHeroHeader extends StatelessWidget {
  const NetWorthHeroHeader({
    super.key,
    required this.netWorth,
    required this.totalAssets,
    required this.totalLiabilities,
  });

  final double netWorth;
  final double totalAssets;
  final double totalLiabilities;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final amountColor = netWorth > 0
        ? AppColors.income
        : netWorth < 0
            ? AppColors.expense
            : scheme.onSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Net worth',
            style: textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            CurrencyFormatter.format(netWorth),
            style: textTheme.displaySmall?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Row(
            children: [
              Expanded(
                child: _BreakdownTile(
                  label: 'Assets',
                  amount: totalAssets,
                  color: AppColors.income,
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: scheme.outline.withValues(alpha: 0.15),
              ),
              Expanded(
                child: _BreakdownTile(
                  label: 'Liabilities',
                  amount: totalLiabilities,
                  color: AppColors.debt,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakdownTile extends StatelessWidget {
  const _BreakdownTile({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSizes.xs),
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            CurrencyFormatter.format(amount),
            style: textTheme.titleMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
