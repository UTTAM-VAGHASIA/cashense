import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:cashense/features/authentication/bindings/authentication_binding.dart';
import 'package:cashense/features/authentication/controllers/authentication_controller.dart';
import 'package:cashense/data/services/authentication_service.dart';

void main() {
  group('AuthenticationBinding', () {
    setUp(() {
      // Reset GetX before each test
      Get.reset();
    });

    tearDown(() {
      // Clean up after each test
      Get.reset();
    });

    test(
      'should register AuthenticationService and AuthenticationController',
      () {
        // Arrange
        final binding = AuthenticationBinding();

        // Act
        binding.dependencies();

        // Assert
        expect(Get.isRegistered<AuthenticationService>(), isTrue);
        expect(Get.isRegistered<AuthenticationController>(), isTrue);
      },
    );

    test('should provide the same AuthenticationService instance', () {
      // Arrange
      final binding = AuthenticationBinding();
      binding.dependencies();

      // Act
      final service1 = Get.find<AuthenticationService>();
      final service2 = Get.find<AuthenticationService>();

      // Assert
      expect(identical(service1, service2), isTrue);
    });

    test('should inject AuthenticationService into AuthenticationController', () {
      // Arrange
      final binding = AuthenticationBinding();
      binding.dependencies();

      // Act
      final controller = Get.find<AuthenticationController>();

      // Assert
      expect(controller, isNotNull);
      // The controller should be able to access the service through dependency injection
      expect(() => controller.isGoogleSignInAvailable(), returnsNormally);
    });
  });
}
