import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Main navigation screen that provides access to all app screens for testing
class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashense - Screen Navigator'),
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                      theme.colorScheme.secondary.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Cashense',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AI-Powered Financial Management',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              // Authentication Screens Section
              _buildSection(
                context,
                title: 'Authentication Screens',
                icon: Icons.login,
                items: [
                  _NavigationItem(
                    title: 'Sign In',
                    subtitle: 'User login screen with form validation',
                    icon: Icons.login,
                    route: '/sign-in',
                    color: Colors.blue,
                  ),
                  _NavigationItem(
                    title: 'Sign Up',
                    subtitle: 'User registration with terms acceptance',
                    icon: Icons.person_add,
                    route: '/sign-up',
                    color: Colors.green,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Settings Screens Section
              _buildSection(
                context,
                title: 'Settings & Configuration',
                icon: Icons.settings,
                items: [
                  _NavigationItem(
                    title: 'Settings',
                    subtitle: 'Main settings page with preferences',
                    icon: Icons.settings,
                    route: '/settings',
                    color: Colors.orange,
                  ),
                  _NavigationItem(
                    title: 'Theme Settings',
                    subtitle: 'Customize app appearance and themes',
                    icon: Icons.palette,
                    route: '/settings/theme',
                    color: Colors.purple,
                  ),
                  _NavigationItem(
                    title: 'Localization Demo',
                    subtitle: 'Multi-language support demonstration',
                    icon: Icons.language,
                    route: '/localization-demo',
                    color: Colors.teal,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Shared Components Section
              _buildSection(
                context,
                title: 'Shared Components',
                icon: Icons.widgets,
                items: [
                  _NavigationItem(
                    title: 'Theme Switcher Demo',
                    subtitle: 'Interactive theme switching components',
                    icon: Icons.brightness_6,
                    route: '/theme-switcher-demo',
                    color: Colors.indigo,
                  ),
                  _NavigationItem(
                    title: 'Language Selector Demo',
                    subtitle: 'Language selection components',
                    icon: Icons.translate,
                    route: '/language-selector-demo',
                    color: Colors.cyan,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Development Tools Section
              _buildSection(
                context,
                title: 'Development Tools',
                icon: Icons.developer_mode,
                items: [
                  _NavigationItem(
                    title: 'Splash Screen',
                    subtitle: 'App initialization and loading screen',
                    icon: Icons.hourglass_empty,
                    route: '/splash',
                    color: Colors.amber,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Footer
              Center(
                child: Text(
                  'Tap any screen above to navigate and test',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<_NavigationItem> items,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _buildNavigationCard(context, item)),
      ],
    );
  }

  Widget _buildNavigationCard(BuildContext context, _NavigationItem item) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () => context.push(item.route),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color color;
}