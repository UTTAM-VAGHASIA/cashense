import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cashense/utils/constants/sizes.dart';

/// Floating action button on the home dashboard.
///
/// Phase 1.1 ships the visual + a placeholder bottom sheet — the real add-
/// transaction flow lands in Phase 1.2 (`add_transaction_screen.dart`).
class QuickAddFab extends StatelessWidget {
  const QuickAddFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _openSheet(context),
      icon: const Icon(Icons.add_rounded),
      label: const Text('Add'),
    );
  }

  void _openSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => const _QuickAddPlaceholder(),
    );
  }
}

class _QuickAddPlaceholder extends StatelessWidget {
  const _QuickAddPlaceholder();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick add',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'Logging transactions ships in Phase 1.2.',
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Row(
              children: [
                _QuickAddTile(
                  icon: Icons.arrow_upward_rounded,
                  label: 'Expense',
                  color: scheme.errorContainer,
                  onColor: scheme.onErrorContainer,
                ),
                const SizedBox(width: AppSizes.md),
                _QuickAddTile(
                  icon: Icons.arrow_downward_rounded,
                  label: 'Income',
                  color: scheme.primaryContainer,
                  onColor: scheme.onPrimaryContainer,
                ),
                const SizedBox(width: AppSizes.md),
                _QuickAddTile(
                  icon: Icons.swap_horiz_rounded,
                  label: 'Transfer',
                  color: scheme.tertiaryContainer,
                  onColor: scheme.onTertiaryContainer,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }
}

class _QuickAddTile extends StatelessWidget {
  const _QuickAddTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onColor,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.1,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: onColor, size: AppSizes.iconLg),
              const SizedBox(height: AppSizes.xs),
              Text(
                label,
                style: TextStyle(
                  color: onColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
