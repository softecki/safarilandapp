import 'package:flutter/material.dart';
import '../view/widget/custom_loader.dart';

/// Navigation helper with custom transitions and loading animations
class NavigationHelper {
  /// Navigate to a new screen with custom fade and scale transition
  static Future<T?> navigateTo<T>(
    BuildContext context,
    Widget destination, {
    bool replace = false,
    bool showLoader = true,
    Duration loaderDuration = const Duration(milliseconds: 300),
  }) async {
    if (showLoader) {
      // Show loader briefly for smooth transition
      LoadingOverlay.show(context);
      await Future.delayed(loaderDuration);
      LoadingOverlay.hide();
    }

    if (replace) {
      return Navigator.pushReplacement(
        context,
        LoaderPageRoute(builder: (_) => destination),
      );
    } else {
      return Navigator.push(
        context,
        LoaderPageRoute(builder: (_) => destination),
      );
    }
  }

  /// Navigate and remove all previous routes
  static Future<T?> navigateAndRemoveUntil<T>(
    BuildContext context,
    Widget destination, {
    bool showLoader = true,
  }) async {
    if (showLoader) {
      LoadingOverlay.show(context);
      await Future.delayed(const Duration(milliseconds: 300));
      LoadingOverlay.hide();
    }

    return Navigator.pushAndRemoveUntil(
      context,
      LoaderPageRoute(builder: (_) => destination),
      (route) => false,
    );
  }

  /// Pop with custom transition
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  /// Show loading dialog
  static void showLoadingDialog(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => WillPopScope(
        onWillPop: () async => barrierDismissible,
        child: SimpleLoader(message: message),
      ),
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

/// Custom slide transition from right
class SlideRightRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideRightRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
}

/// Custom slide transition from bottom
class SlideUpRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideUpRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        );
}
