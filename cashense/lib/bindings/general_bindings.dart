import 'package:get/get.dart';
import 'package:cashense/features/authentication/bindings/authentication_binding.dart';

/// General bindings for the entire application
/// This class sets up all the dependencies that should be available app-wide
class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize authentication dependencies
    AuthenticationBinding().dependencies();
  }
}