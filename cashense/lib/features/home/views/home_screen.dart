import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:cashense/features/authentication/controllers/authentication_controller.dart';
import 'package:cashense/features/authentication/models/app_user.dart';
import 'package:cashense/features/home/controllers/home_controller.dart';
import 'package:cashense/features/home/widgets/balance_card.dart';
import 'package:cashense/features/home/widgets/budget_summary_card.dart';
import 'package:cashense/features/home/widgets/quick_add_fab.dart';
import 'package:cashense/features/home/widgets/recent_transactions.dart';
import 'package:cashense/routes/routes.dart';
import 'package:cashense/utils/constants/sizes.dart';
import 'package:cashense/utils/device/device_utility.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthenticationController>();
    final home = Get.find<HomeController>();
    final isDesktop = AppDeviceUtils.isDesktopScreen(context);
    final isTablet = AppDeviceUtils.isTabletScreen(context);
    final maxWidth = isDesktop ? 720.0 : (isTablet ? 600.0 : double.infinity);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: RefreshIndicator(
              onRefresh: home.refreshDashboard,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.lg,
                        AppSizes.md,
                        AppSizes.lg,
                        AppSizes.md,
                      ),
                      child: Obx(
                        () => _Header(user: auth.user),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.lg,
                      ),
                      child: Obx(
                        () => BalanceCard(
                          totalBalance: home.totalBalance,
                          monthlyIncome: home.monthlyIncome,
                          monthlyExpense: home.monthlyExpense,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSizes.lg),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.lg,
                      ),
                      child: Obx(
                        () => RecentTransactions(
                          transactions: home.recentTransactions,
                          onSeeAll: () =>
                              context.go(AppRoutes.transactions),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSizes.lg),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.lg,
                      ),
                      child: Obx(
                        () => BudgetSummaryCard(
                          usages: home.budgetUsage,
                          onSeeAll: () => context.go(AppRoutes.budgets),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSizes.xl * 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: const QuickAddFab(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.user});
  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final firstName = user?.firstName ??
        (user?.displayName?.split(' ').firstOrNull) ??
        'there';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting(),
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSizes.xs / 2),
              Text(
                'Hi, $firstName',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        _ProfileAvatar(user: user),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({this.user});
  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final initials = _initials(user);

    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () => context.push(AppRoutes.profile),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scheme.primaryContainer,
          border: Border.all(
            color: scheme.outline.withValues(alpha: 0.15),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: user?.photoURL != null
            ? Image.network(
                user!.photoURL!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    _fallback(initials, scheme, textTheme),
              )
            : _fallback(initials, scheme, textTheme),
      ),
    );
  }

  Widget _fallback(String initials, ColorScheme scheme, TextTheme textTheme) {
    return Center(
      child: initials.isNotEmpty
          ? Text(
              initials,
              style: textTheme.titleMedium?.copyWith(
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            )
          : Icon(
              Icons.person_rounded,
              color: scheme.onPrimaryContainer,
            ),
    );
  }

  String _initials(AppUser? user) {
    if (user == null) return '';
    final name = user.displayName?.trim() ?? '';
    if (name.isNotEmpty) {
      final parts = name.split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      }
      return parts.first[0].toUpperCase();
    }
    if (user.email.isNotEmpty) return user.email[0].toUpperCase();
    return '';
  }
}
