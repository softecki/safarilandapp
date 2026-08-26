import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SafariTheme {
  /// Deep maroon from the Safari Land brand artwork.
  static const maroon = Color(0xFF800D12);
  static const maroonDark = Color(0xFF5C090D);
  static const black = Color(0xFF111111);
  static const canvas = Color(0xFFF7F4F2);
  static const muted = Color(0xFF6B6259);

  /// Legacy aliases used by older Safari widgets.
  static const green = maroon;
  static const greenDark = maroonDark;
  static const sand = canvas;
  static const earth = maroon;
  static const gold = maroon;
  static const ink = black;

  static ThemeData material() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: maroon,
        onPrimary: Colors.white,
        secondary: black,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: black,
        error: maroon,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: canvas,
      dividerColor: black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: maroon,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: black,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: maroon),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFDDD6D0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFDDD6D0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: maroon, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: maroon,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.1),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: maroon,
          side: const BorderSide(color: maroon),
          minimumSize: const Size.fromHeight(48),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: maroon,
        foregroundColor: Colors.white,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: maroon),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? maroon : null),
      ),
      snackBarTheme: const SnackBarThemeData(backgroundColor: maroon, contentTextStyle: TextStyle(color: Colors.white)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: maroon,
        unselectedItemColor: muted,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
    try {
      return base.copyWith(
        textTheme: GoogleFonts.montserratTextTheme(base.textTheme).apply(bodyColor: black, displayColor: black),
      );
    } catch (_) {
      return base;
    }
  }
}
