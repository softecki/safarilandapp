import 'package:flutter/material.dart' show Color;

class AppColor {
  const AppColor._();

  static const darkOrange = Color(0xFFEC6813);
  /// FaidaBiz brand (green).
  static const primaryColor = Color(0xFF15803D);
  /// Darker green for accents.
  static const primaryLight = Color(0xFF4ADE80);
  static const lightOrange = Color(0xFFf8b89a);

  static const darkGrey = Color(0xFFA6A3A0);
  static const lightGrey = Color(0xFFE5E6E8);

  /// Soft green-tinted canvas for [flutter_neumorphic_plus] surfaces.
  static const neumorphicBase = Color(0xFFF0F7F2);
  /// Slightly elevated panels / cards on the base.
  static const neumorphicSurface = Color(0xFFFAFDFB);
  /// Dark neumorphic canvas (optional dark mode).
  static const neumorphicBaseDark = Color(0xFF1A2228);

  // Text colors
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF666666);
}
