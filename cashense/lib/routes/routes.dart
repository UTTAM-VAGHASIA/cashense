/// Centralised named-route constants for the app.
///
/// Use these everywhere instead of hard-coded strings so renames are
/// tracked by the compiler.
class AppRoutes {
  AppRoutes._();

  // Auth flow
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String biometrics = '/biometrics';

  // Core
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Phase 1 — Core finance
  static const String transactions = '/transactions';
  static const String accounts = '/accounts';
  static const String budgets = '/budgets';
  static const String bills = '/bills';

  // Phase 2 — Social finance
  static const String groups = '/groups';
  static const String groupDetail = '/group/:id';
  static String groupDetailPath(String id) => '/group/$id';

  // Phase 3 — Wealth
  static const String assets = '/assets';
  static const String liabilities = '/liabilities';
  static const String netWorth = '/net-worth';
  static const String goals = '/goals';

  // Phase 4 — Protect
  static const String insurance = '/insurance';

  // Phase 5 — Intelligence
  static const String analytics = '/analytics';
  static const String aiChat = '/ai-chat';

  /// Routes a signed-out user is allowed to be on.
  static const Set<String> publicRoutes = {splash, welcome, login};
}
