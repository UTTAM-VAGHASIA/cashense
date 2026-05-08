import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:cashense/features/authentication/controllers/authentication_controller.dart';
import 'package:cashense/features/authentication/views/biometrics_page.dart';
import 'package:cashense/features/authentication/views/login_screen.dart';
import 'package:cashense/features/authentication/views/welcome_screen.dart';
import 'package:cashense/features/home/bindings/home_binding.dart';
import 'package:cashense/features/home/views/home_screen.dart';
import 'package:cashense/routes/routes.dart';
import 'package:cashense/routes/routes_middleware.dart';
import 'package:cashense/routes/routes_observer.dart';

/// Builds and owns the top-level [GoRouter] for the app.
///
/// Routes for unbuilt features point to [_ComingSoonScreen]. As each phase
/// ships its feature, swap the placeholder for the real screen.
class AppRoutePages {
  AppRoutePages._();

  static GoRouter? _router;

  static GoRouter get router {
    return _router ??= _build();
  }

  static GoRouter _build() {
    final auth = Get.find<AuthenticationController>();
    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      observers: [AppRouteObserver()],
      refreshListenable: AuthRefreshNotifier(auth),
      redirect: AuthGuard.redirect,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash',
          builder: (_, _) => const _SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.welcome,
          name: 'welcome',
          builder: (_, _) => const WelcomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (_, _) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.biometrics,
          name: 'biometrics',
          builder: (_, _) => const BiometricsPage(),
        ),

        // Stubbed routes — wire to real screens as features ship.
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (_, _) {
            HomeBinding().dependencies();
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.profile,
          name: 'profile',
          builder: (_, _) => const _ComingSoonScreen(title: 'Profile'),
        ),
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          builder: (_, _) => const _ComingSoonScreen(title: 'Settings'),
        ),
        GoRoute(
          path: AppRoutes.transactions,
          name: 'transactions',
          builder: (_, _) => const _ComingSoonScreen(title: 'Transactions'),
        ),
        GoRoute(
          path: AppRoutes.accounts,
          name: 'accounts',
          builder: (_, _) => const _ComingSoonScreen(title: 'Accounts'),
        ),
        GoRoute(
          path: AppRoutes.budgets,
          name: 'budgets',
          builder: (_, _) => const _ComingSoonScreen(title: 'Budgets'),
        ),
        GoRoute(
          path: AppRoutes.bills,
          name: 'bills',
          builder: (_, _) => const _ComingSoonScreen(title: 'Bills'),
        ),
        GoRoute(
          path: AppRoutes.groups,
          name: 'groups',
          builder: (_, _) => const _ComingSoonScreen(title: 'Groups'),
        ),
        GoRoute(
          path: AppRoutes.groupDetail,
          name: 'group_detail',
          builder: (_, state) => _ComingSoonScreen(
            title: 'Group ${state.pathParameters['id'] ?? ''}',
          ),
        ),
        GoRoute(
          path: AppRoutes.assets,
          name: 'assets',
          builder: (_, _) => const _ComingSoonScreen(title: 'Assets'),
        ),
        GoRoute(
          path: AppRoutes.liabilities,
          name: 'liabilities',
          builder: (_, _) => const _ComingSoonScreen(title: 'Liabilities'),
        ),
        GoRoute(
          path: AppRoutes.netWorth,
          name: 'net_worth',
          builder: (_, _) => const _ComingSoonScreen(title: 'Net Worth'),
        ),
        GoRoute(
          path: AppRoutes.goals,
          name: 'goals',
          builder: (_, _) => const _ComingSoonScreen(title: 'Goals'),
        ),
        GoRoute(
          path: AppRoutes.insurance,
          name: 'insurance',
          builder: (_, _) => const _ComingSoonScreen(title: 'Insurance'),
        ),
        GoRoute(
          path: AppRoutes.analytics,
          name: 'analytics',
          builder: (_, _) => const _ComingSoonScreen(title: 'Analytics'),
        ),
        GoRoute(
          path: AppRoutes.aiChat,
          name: 'ai_chat',
          builder: (_, _) => const _ComingSoonScreen(title: 'AI Assistant'),
        ),
      ],
      errorBuilder: (_, state) => _ErrorScreen(error: state.error),
    );
  }
}

/// Minimal splash — the redirect logic in [AuthGuard] takes the user away
/// once [AuthenticationController] resolves.
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                size: 40,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Cashense',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonScreen extends StatelessWidget {
  const _ComingSoonScreen({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 56, color: scheme.primary),
            const SizedBox(height: 16),
            Text(
              '$title — coming soon',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({this.error});
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(child: Text(error?.toString() ?? 'Route not found')),
    );
  }
}
