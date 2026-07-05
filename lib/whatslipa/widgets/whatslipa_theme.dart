import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/whatslipa_brand.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

/// Uniform brand styling for all WhatsLipa screens.
class WhatsLipaTheme {
  WhatsLipaTheme._();

  static Color get primary => WhatsLipaBrand.primary;
  static Color get secondary => WhatsLipaBrand.secondary;

  static AppBarTheme appBarTheme() => AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      );

  static ThemeData materialTheme() {
    final p = primary;
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColor.neumorphicBase,
      colorScheme: ColorScheme.fromSeed(seedColor: p, primary: p, brightness: Brightness.light),
      appBarTheme: appBarTheme(),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return p;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return p;
            return Colors.white;
          }),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: p, foregroundColor: Colors.white),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static PreferredSizeWidget appBar({
    String title = '',
    Widget? titleWidget,
    List<Widget>? actions,
    Widget? leading,
    Color? accentColor,
  }) {
    return WhatsLipaStyledAppBar(
      title: title,
      titleWidget: titleWidget,
      actions: actions,
      leading: leading,
      accentColor: accentColor,
    );
  }

  static NeumorphicStyle accentCircle() => NeumorphicStyle(
        depth: 6,
        boxShape: const NeumorphicBoxShape.circle(),
        color: primary,
      );
}
