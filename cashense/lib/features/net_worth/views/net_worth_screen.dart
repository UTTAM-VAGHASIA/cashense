import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:cashense/features/net_worth/controllers/net_worth_controller.dart';
import 'package:cashense/features/net_worth/widgets/net_worth_empty_state.dart';
import 'package:cashense/features/net_worth/widgets/net_worth_hero_header.dart';
import 'package:cashense/routes/routes.dart';
import 'package:cashense/utils/constants/sizes.dart';
import 'package:cashense/utils/device/device_utility.dart';

/// The Net Worth dashboard — hero surface of the Wealth tab.
///
/// Phase A renders the ₹0 hero header plus the "Add your first asset" empty
/// state. Phase B/C fill in the asset pie and monthly trend below the header.
class NetWorthScreen extends StatelessWidget {
  const NetWorthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NetWorthController>();
    final isDesktop = AppDeviceUtils.isDesktopScreen(context);
    final isTablet = AppDeviceUtils.isTabletScreen(context);
    final maxWidth = isDesktop ? 720.0 : (isTablet ? 600.0 : double.infinity);

    return Scaffold(
      appBar: AppBar(title: const Text('Net worth')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: RefreshIndicator(
              onRefresh: controller.refreshNetWorth,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.lg,
                        AppSizes.md,
                        AppSizes.lg,
                        AppSizes.lg,
                      ),
                      child: Obx(
                        () => NetWorthHeroHeader(
                          netWorth: controller.netWorth,
                          totalAssets: controller.totalAssets,
                          totalLiabilities: controller.totalLiabilities,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.lg,
                        AppSizes.xl,
                        AppSizes.lg,
                        AppSizes.lg,
                      ),
                      // When assets/liabilities land (Phase B/C) this branch
                      // renders the pie + breakdown instead of the CTA.
                      child: Obx(
                        () => controller.isEmpty
                            ? NetWorthEmptyState(
                                onAddAsset: () => context.push(AppRoutes.assets),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
