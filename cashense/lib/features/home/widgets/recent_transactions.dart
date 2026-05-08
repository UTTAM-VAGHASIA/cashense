import 'package:flutter/material.dart';
import 'package:cashense/data/models/transaction_model.dart';
import 'package:cashense/utils/constants/sizes.dart';
import 'package:cashense/utils/formatters/currency_formatter.dart';
import 'package:cashense/utils/formatters/date_formatters.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({
    super.key,
    required this.transactions,
    required this.onSeeAll,
  });

  final List<TransactionModel> transactions;
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
                'Recent transactions',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: const Text('See all'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        if (transactions.isEmpty)
          _EmptyState(scheme: scheme, textTheme: textTheme)
        else
          Container(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
              border: Border.all(
                color: scheme.outline.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                for (var i = 0; i < transactions.length; i++) ...[
                  _TransactionTile(transaction: transactions[i]),
                  if (i != transactions.length - 1)
                    Divider(
                      height: 1,
                      indent: AppSizes.lg,
                      endIndent: AppSizes.md,
                      color: scheme.outline.withValues(alpha: 0.08),
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isExpense = transaction.type == TransactionType.expense;
    final sign = isExpense ? '-' : '+';
    final amountColor = isExpense ? scheme.error : Colors.green.shade700;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
            ),
            child: Icon(
              _iconFor(transaction.category),
              color: scheme.onPrimaryContainer,
              size: AppSizes.iconMd,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.note?.isNotEmpty == true
                      ? transaction.note!
                      : DateFormatters.toDayMonthShort(transaction.date),
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '$sign${CurrencyFormatter.format(transaction.amount)}',
            style: textTheme.titleSmall?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'transport':
        return Icons.directions_car_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'rent':
        return Icons.home_rounded;
      case 'health':
        return Icons.medical_services_rounded;
      case 'salary':
        return Icons.account_balance_wallet_rounded;
      case 'investment':
        return Icons.trending_up_rounded;
      case 'emi':
        return Icons.receipt_long_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.scheme, required this.textTheme});
  final ColorScheme scheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.xl,
        horizontal: AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: AppSizes.iconLg,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'No transactions yet',
            style: textTheme.titleSmall?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Tap the + button to log your first one.',
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
