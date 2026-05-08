import 'package:flutter/material.dart';
import 'package:cashense/features/home/controllers/home_controller.dart';
import 'package:cashense/utils/constants/sizes.dart';
import 'package:cashense/utils/formatters/currency_formatter.dart';

class BudgetSummaryCard extends StatelessWidget {
  const BudgetSummaryCard({
    super.key,
    required this.usages,
    required this.onSeeAll,
  });

  final List<CategoryBudgetUsage> usages;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budgets this month',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: const Text('Manage'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        if (usages.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.xl,
              horizontal: AppSizes.md,
            ),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
              border: Border.all(
                color: scheme.outline.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.pie_chart_outline_rounded,
                  size: AppSizes.iconLg,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'No budgets set',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Set monthly limits per category to track spending.',
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
              border: Border.all(
                color: scheme.outline.withValues(alpha: 0.1),
              ),
            ),
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              children: [
                for (var i = 0; i < usages.length; i++) ...[
                  _BudgetRow(usage: usages[i]),
                  if (i != usages.length - 1)
                    const SizedBox(height: AppSizes.md),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _BudgetRow extends StatelessWidget {
  const _BudgetRow({required this.usage});
  final CategoryBudgetUsage usage;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = _statusColor(scheme, usage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              usage.category,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${CurrencyFormatter.compact(usage.spent)} / ${CurrencyFormatter.compact(usage.budgeted)}',
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
          child: LinearProgressIndicator(
            value: usage.percentUsed.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: scheme.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Color _statusColor(ColorScheme scheme, CategoryBudgetUsage u) {
    if (u.isOver) return scheme.error;
    if (u.isWarning) return Colors.orange.shade700;
    return scheme.primary;
  }
}
