import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Simple navigation screen for testing all UI screens
class SimpleNavigationScreen extends StatelessWidget {
  const SimpleNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashense - Screen Navigator'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.account_balance_wallet, size: 48),
                      SizedBox(height: 8),
                      Text(
                        'Cashense',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('AI-Powered Financial Management'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Navigation buttons
              Expanded(
                child: ListView(
                  children: [
                    _buildNavButton(
                      context,
                      'Sign In Page',
                      'User authentication screen',
                      Icons.login,
                      '/sign-in',
                    ),
                    _buildNavButton(
                      context,
                      'Sign Up Page',
                      'User registration screen',
                      Icons.person_add,
                      '/sign-up',
                    ),
                    _buildNavButton(
                      context,
                      'Home Page',
                      'Main application screen',
                      Icons.home,
                      '/home',
                    ),
                    _buildNavButton(
                      context,
                      'Settings',
                      'App settings and preferences',
                      Icons.settings,
                      '/settings',
                    ),
                    _buildNavButton(
                      context,
                      'Theme Settings',
                      'Customize app appearance',
                      Icons.palette,
                      '/settings/theme',
                    ),
                    _buildNavButton(
                      context,
                      'Localization Demo',
                      'Multi-language support',
                      Icons.language,
                      '/localization-demo',
                    ),
                    _buildNavButton(
                      context,
                      'Theme Switcher Demo',
                      'Theme switching components',
                      Icons.brightness_6,
                      '/theme-switcher-demo',
                    ),
                    _buildNavButton(
                      context,
                      'Language Selector Demo',
                      'Language selection components',
                      Icons.translate,
                      '/language-selector-demo',
                    ),
                    _buildNavButton(
                      context,
                      'Splash Screen',
                      'App loading screen',
                      Icons.hourglass_empty,
                      '/splash',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String route,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => context.push(route),
      ),
    );
  }
}
