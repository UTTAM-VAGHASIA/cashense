// Barrel file that exports all ViewModels and their providers
// This file provides a centralized location for all Riverpod providers
// used throughout the application for dependency injection.

// Core providers are now imported from their respective feature modules

// Settings ViewModels and Providers
export 'features/settings/settings_viewmodel.dart'
    show
        settingsViewModelProvider,
        SettingsViewModel,
        sharedPreferencesProvider;

// App-level Providers
export '../app/theme/app_theme.dart' show themeModeProvider, ThemeModeNotifier;
export '../app/theme/theme_service.dart'
    show
        themeConfigProvider,
        themeServiceProvider,
        lightThemeProvider,
        darkThemeProvider,
        dynamicColorSchemesProvider;
export '../app/router/app_router.dart' show appRouterProvider, RouteNames;
export '../app/localization/locale_provider.dart'
    show
        localeProvider,
        LocaleNotifier,
        isRTLProvider,
        textDirectionProvider,
        currentLanguageDisplayNameProvider,
        supportedLocalesWithNamesProvider,
        LocaleInfo;

// Utility exports
export '../utils/result.dart';
export '../utils/exceptions.dart';

// TODO: Add other feature ViewModels as they are migrated
// export 'features/authentication/authentication_viewmodel.dart';
// export 'features/accounts/accounts_viewmodel.dart';
// export 'features/transactions/transactions_viewmodel.dart';
// export 'features/budgets/budgets_viewmodel.dart';
// export 'features/analytics/analytics_viewmodel.dart';
// export 'features/groups/groups_viewmodel.dart';

// TODO: Add shared ViewModels as they are created
// export 'shared/app_state_viewmodel.dart';
// export 'shared/navigation_viewmodel.dart';
