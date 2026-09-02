import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SafariTheme {
  static const maroon = Color(0xFF6E0B12);
  static const maroonDark = Color(0xFF3F070B);
  static const gold = Color(0xFFC6A15B);
  static const goldSoft = Color(0xFFE8D5A3);
  static const black = Color(0xFF1A1412);
  static const canvas = Color(0xFFF6F0E8);
  static const muted = Color(0xFF7A7066);
  static const cream = Color(0xFFFFFBF6);

  static const green = maroon;
  static const greenDark = maroonDark;
  static const sand = canvas;
  static const earth = maroon;
  static const ink = black;

  static ThemeData material() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: maroon,
        onPrimary: Colors.white,
        secondary: gold,
        onSecondary: maroonDark,
        surface: cream,
        onSurface: black,
        error: Color(0xFFB3261E),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: canvas,
      dividerColor: const Color(0xFFE4D9CC),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: maroon,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: black,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        iconTheme: IconThemeData(color: maroon),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE4D9CC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE4D9CC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: gold, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: maroon,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.4, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: maroon,
          side: const BorderSide(color: gold, width: 1.2),
          minimumSize: const Size.fromHeight(50),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: maroon,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: gold),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: maroonDark,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: maroon,
        unselectedItemColor: muted,
        backgroundColor: cream,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
    try {
      return base.copyWith(
        textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
          displaySmall: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: black, fontSize: 28),
          headlineMedium: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: black, fontSize: 22),
          headlineSmall: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700, color: black, fontSize: 18),
        ).apply(bodyColor: black, displayColor: black),
      );
    } catch (_) {
      return base;
    }
  }
}
