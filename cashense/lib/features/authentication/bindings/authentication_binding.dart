import 'package:get/get.dart';
import 'package:cashense/features/authentication/controllers/authentication_controller.dart';
import 'package:cashense/data/services/authentication_service.dart';

/// Authentication binding for dependency injection
/// Configures dependencies for the authentication feature
class AuthenticationBinding extends Bindings {
  @override
  void dependencies() {
    // Register AuthenticationService as a singleton
    // Since AuthenticationService already implements singleton pattern,
    // we use Get.put to register the existing instance
    Get.put<AuthenticationService>(
      AuthenticationService(),
      permanent: true, // Keep it in memory permanently
    );

    // Register AuthenticationController as a singleton
    // It will automatically receive the AuthenticationService dependency
    Get.lazyPut<AuthenticationController>(
      () => AuthenticationController(),
      fenix: true, // Allows recreation if disposed
    );
  }
}
