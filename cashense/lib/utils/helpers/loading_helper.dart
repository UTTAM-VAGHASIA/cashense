import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashense/utils/constants/sizes.dart';
import 'package:cashense/utils/helpers/dialog_helper.dart';

/// Helper class for managing loading states and overlays
class LoadingHelper {
  LoadingHelper._();

  static bool _isLoading = false;

  /// Show loading overlay
  static void show({
    String message = 'Loading...',
    bool barrierDismissible = false,
  }) {
    if (_isLoading) return;

    _isLoading = true;
    DialogHelper.showLoading(
      message: message,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Hide loading overlay
  static void hide() {
    if (!_isLoading) return;

    _isLoading = false;
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  /// Check if loading is currently shown
  static bool get isLoading => _isLoading;

  /// Execute function with loading overlay
  static Future<T?> execute<T>(
    Future<T> Function() function, {
    String message = 'Loading...',
    bool barrierDismissible = false,
    Duration? timeout,
  }) async {
    try {
      show(message: message, barrierDismissible: barrierDismissible);

      if (timeout != null) {
        return await function().timeout(timeout);
      } else {
        return await function();
      }
    } catch (e) {
      rethrow;
    } finally {
      hide();
    }
  }

  /// Show loading with progress indicator
  static void showProgress({
    String message = 'Loading...',
    double? progress,
    bool barrierDismissible = false,
  }) {
    if (_isLoading) return;

    _isLoading = true;
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (progress != null) ...[
              LinearProgressIndicator(value: progress),
              const SizedBox(height: AppSizes.md),
              Text('${(progress * 100).toInt()}%'),
            ] else ...[
              const CircularProgressIndicator(),
            ],
            const SizedBox(height: AppSizes.md),
            Text(message),
          ],
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Update progress
  static void updateProgress(double progress, {String? message}) {
    if (!_isLoading) return;

    // This would require a more complex implementation with a custom dialog
    // For now, we'll hide and show with new progress
    hide();
    showProgress(
      progress: progress,
      message: message ?? 'Loading...',
    );
  }

  /// Show loading with custom widget
  static void showCustom({
    required Widget content,
    bool barrierDismissible = false,
    Color? backgroundColor,
  }) {
    if (_isLoading) return;

    _isLoading = true;
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        ),
        backgroundColor: backgroundColor,
        content: content,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Show loading with animation
  static void showAnimated({
    String message = 'Loading...',
    bool barrierDismissible = false,
    Duration animationDuration = const Duration(milliseconds: 300),
  }) {
    if (_isLoading) return;

    _isLoading = true;
    Get.dialog(
      AnimatedContainer(
        duration: animationDuration,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LoadingAnimation(),
              const SizedBox(height: AppSizes.md),
              Text(message),
            ],
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Force hide all loading dialogs
  static void forceHide() {
    _isLoading = false;
    while (Get.isDialogOpen!) {
      Get.back();
    }
  }
}

/// Custom loading animation widget
class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * 2 * 3.14159,
          child: Container(
            width: AppSizes.loadingIndicatorSize,
            height: AppSizes.loadingIndicatorSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.3),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.refresh,
                color: Colors.white,
                size: AppSizes.iconMd,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Loading overlay widget for use in screens
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String message;
  final Color? overlayColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message = 'Loading...',
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Shimmer loading effect widget
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation =
        Tween<double>(
          begin: -1.0,
          end: 2.0,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? Colors.grey.shade300;
    final highlightColor = widget.highlightColor ?? Colors.grey.shade100;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              transform: GradientRotation(_animation.value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
