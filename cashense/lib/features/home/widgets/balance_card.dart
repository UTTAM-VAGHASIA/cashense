import 'package:flutter/material.dart';
import 'package:cashense/utils/constants/sizes.dart';
import 'package:cashense/utils/formatters/currency_formatter.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
  });

  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary,
            Color.alphaBlend(
              scheme.primary.withValues(alpha: 0.85),
              scheme.tertiary,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total balance',
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onPrimary.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            CurrencyFormatter.format(totalBalance),
            style: textTheme.headlineMedium?.copyWith(
              color: scheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Row(
            children: [
              Expanded(
                child: _MonthlyTile(
                  label: 'Income',
                  amount: monthlyIncome,
                  icon: Icons.arrow_downward_rounded,
                  fg: scheme.onPrimary,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: scheme.onPrimary.withValues(alpha: 0.25),
              ),
              Expanded(
                child: _MonthlyTile(
                  label: 'Expenses',
                  amount: monthlyExpense,
                  icon: Icons.arrow_upward_rounded,
                  fg: scheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthlyTile extends StatelessWidget {
  const _MonthlyTile({
    required this.label,
    required this.amount,
    required this.icon,
    required this.fg,
  });

  final String label;
  final double amount;
  final IconData icon;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppSizes.iconSm, color: fg),
              const SizedBox(width: AppSizes.xs),
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: fg.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            CurrencyFormatter.compact(amount),
            style: textTheme.titleMedium?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
