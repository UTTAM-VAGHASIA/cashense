import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../views/shared/splash_screen.dart';
import '../../views/shared/simple_navigation.dart';
import '../../views/shared/demo_screens/theme_switcher_demo.dart';
import '../../views/shared/demo_screens/language_selector_demo.dart';
import '../../views/features/index.dart';

/// Provider for the app router configuration with enhanced error handling
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,

    // Enhanced redirect logic with authentication state
    redirect: (context, state) {
      // TODO: Add authentication state checking here
      // final isAuthenticated = ref.read(authStateProvider).isAuthenticated;
      if (
      // !isAuthenticated &&
      !_isPublicRoute(state.matchedLocation)) {
        return '/sign-in';
      }
      return null; // No redirect needed
    },

    routes: [
      // Main navigation screen (entry point for testing)
      GoRoute(
        path: '/',
        name: RouteNames.mainNavigation,
        builder: (context, state) => const SimpleNavigationScreen(),
      ),

      // Splash screen with loading state
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Authentication routes with proper transitions
      GoRoute(
        path: '/sign-in',
        name: RouteNames.signIn,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const SignInPage()),
      ),

      GoRoute(
        path: '/sign-up',
        name: RouteNames.signUp,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const SignUpPage()),
      ),

      // Settings and configuration routes
      GoRoute(
        path: '/settings',
        name: RouteNames.settings,
        pageBuilder: (context, state) =>
            _buildPageWithTransition(context, state, const SettingsPage()),
      ),

      GoRoute(
        path: '/settings/theme',
        name: RouteNames.themeSettings,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const ThemeSettingsPage(),
        ),
      ),

      GoRoute(
        path: '/localization-demo',
        name: RouteNames.localizationDemo,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const LocalizationDemoPage(),
        ),
      ),

      // Demo screens for shared components
      GoRoute(
        path: '/theme-switcher-demo',
        name: RouteNames.themeSwitcherDemo,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const ThemeSwitcherDemoScreen(),
        ),
      ),

      GoRoute(
        path: '/language-selector-demo',
        name: RouteNames.languageSelectorDemo,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const LanguageSelectorDemoScreen(),
        ),
      ),

      // Main app routes with nested navigation
      ShellRoute(
        builder: (context, state, child) => _MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: RouteNames.home,
            pageBuilder: (context, state) =>
                _buildPageWithTransition(context, state, const _HomePage()),
          ),
        ],
      ),
    ],

    // Enhanced error handling with logging and recovery options
    errorBuilder: (context, state) {
      developer.log(
        'Router error: ${state.error}',
        name: 'AppRouter',
        error: state.error,
      );

      return _ErrorPage(
        error: state.error.toString(),
        location: state.matchedLocation,
      );
    },
  );
});

/// Route names for type-safe navigation
class RouteNames {
  RouteNames._(); // Private constructor

  static const String mainNavigation = 'mainNavigation';
  static const String splash = 'splash';
  static const String signIn = 'signIn';
  static const String signUp = 'signUp';
  static const String home = 'home';
  static const String settings = 'settings';
  static const String themeSettings = 'themeSettings';
  static const String localizationDemo = 'localizationDemo';
  static const String themeSwitcherDemo = 'themeSwitcherDemo';
  static const String languageSelectorDemo = 'languageSelectorDemo';
}

/// Helper function to build pages with consistent transitions
Page<void> _buildPageWithTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(
          Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut)),
        ),
        child: child,
      );
    },
  );
}

/// Check if route is public (doesn't require authentication)
bool _isPublicRoute(String location) {
  const publicRoutes = [
    '/',
    '/splash',
    '/sign-in',
    '/sign-up',
    '/settings',
    '/settings/theme',
    '/localization-demo',
    '/theme-switcher-demo',
    '/language-selector-demo',
  ];
  return publicRoutes.any((route) => location.startsWith(route));
}

/// Main shell for authenticated routes with navigation
class _MainShell extends StatelessWidget {
  const _MainShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/'),
        icon: const Icon(Icons.home),
        label: const Text('Navigator'),
        tooltip: 'Go to main navigation',
      ),
    );
  }
}

/// Enhanced error page with recovery options
class _ErrorPage extends StatelessWidget {
  const _ErrorPage({required this.error, required this.location});

  final String error;
  final String location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Page Not Found',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'The page you\'re looking for doesn\'t exist or has been moved.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Location: $location',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer.withValues(
                    alpha: 0.7,
                  ),
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Recovery options
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.home),
                    label: const Text('Go Home'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/splash'),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Restart'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Debug information in debug mode
              if (kDebugMode) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Debug Information:',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Temporary home page implementation
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashense Home'),
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.apps),
            onPressed: () => context.go('/'),
            tooltip: 'All Screens',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 80,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to Cashense',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your AI-powered financial companion',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.explore),
                label: const Text('Explore All Screens'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
