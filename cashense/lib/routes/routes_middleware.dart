import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:cashense/features/authentication/controllers/authentication_controller.dart';
import 'package:cashense/routes/routes.dart';

/// Bridge GetX reactive auth state to a [Listenable] so [GoRouter] can
/// re-evaluate redirects whenever the user signs in or out.
class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier(AuthenticationController auth) {
    _userSub = ever<dynamic>(auth.userObs, (_) => notifyListeners());
    _loadingSub = ever<bool>(auth.isLoadingObs, (_) => notifyListeners());
  }

  late final Worker _userSub;
  late final Worker _loadingSub;

  @override
  void dispose() {
    _userSub.dispose();
    _loadingSub.dispose();
    super.dispose();
  }
}

/// Auth guard that decides redirects for every navigation event.
///
/// Rules:
/// - While auth is still resolving, hold the user on `/splash`.
/// - Signed-out users may only visit [AppRoutes.publicRoutes].
/// - Signed-in users on a public route are pushed to `/home`.
class AuthGuard {
  AuthGuard._();

  static String? redirect(BuildContext context, GoRouterState state) {
    final auth = Get.find<AuthenticationController>();
    final location = state.matchedLocation;
    final isPublic = AppRoutes.publicRoutes.contains(location);

    if (auth.isLoading && auth.user == null) {
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }

    if (!auth.isAuthenticated) {
      if (isPublic && location != AppRoutes.splash) return null;
      return AppRoutes.welcome;
    }

    if (isPublic) return AppRoutes.home;

    return null;
  }
}
