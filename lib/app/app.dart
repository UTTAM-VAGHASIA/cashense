import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import '../l10n/app_localizations.dart';

/// The main Cashense application widget
class CashenseApp extends ConsumerWidget {
  const CashenseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp.router(
          title: 'Cashense',
          debugShowCheckedModeBanner: false,

          // Routing
          routerConfig: router,

          // Theming
          theme: AppTheme.light(lightDynamic),
          darkTheme: AppTheme.dark(darkDynamic),
          themeMode: themeMode,

          // Localization
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,

          // Performance optimizations
          builder: (context, child) {
            return MediaQuery(
              // Prevent font scaling beyond reasonable limits for financial data
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.3),
                ),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
