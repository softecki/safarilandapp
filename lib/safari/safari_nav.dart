import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_theme.dart';

class SafariTabs {
  static const home = 0;
  static const trips = 1;
  static const qr = 2;
  static const wallet = 3;
  static const profile = 4;
  static final ValueNotifier<int> index = ValueNotifier(0);

  static void go(int i) => index.value = i;
}

class SafariNav {
  static Route<T> slide<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: SafariTheme.motion,
      reverseTransitionDuration: const Duration(milliseconds: 180),
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween(begin: const Offset(0.12, 0), end: Offset.zero).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }

  static Route<T> fade<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: SafariTheme.motion,
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: child,
      ),
    );
  }

  static Route<T> up<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: SafariTheme.motion,
      reverseTransitionDuration: const Duration(milliseconds: 180),
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }

  static Route<T> scale<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: SafariTheme.motion,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.94, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.push<T>(context, slide<T>(page));
  }

  static Future<T?> pushUp<T>(BuildContext context, Widget page) {
    return Navigator.push<T>(context, up<T>(page));
  }

  static Future<T?> replace<T>(BuildContext context, Widget page) {
    return Navigator.pushReplacement<T, T>(context, fade<T>(page));
  }

  static void reset(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(context, scale(page), (_) => false);
  }
}

class SafariPasswordField extends StatefulWidget {
  const SafariPasswordField({super.key, required this.controller, this.label = 'Password'});
  final TextEditingController controller;
  final String label;

  @override
  State<SafariPasswordField> createState() => _SafariPasswordFieldState();
}

class _SafariPasswordFieldState extends State<SafariPasswordField> {
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: hide,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          onPressed: () => setState(() => hide = !hide),
          icon: Icon(hide ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: SafariTheme.muted),
        ),
      ),
    );
  }
}
