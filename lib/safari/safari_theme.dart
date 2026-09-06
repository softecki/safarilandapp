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
  static const cardBorder = Color(0xFFEEE5D6);
  static const statFill = Color(0xFFFAF5F0);
  static const altFill = Color(0xFFF0E8DC);
  static const pillFill = Color(0xFFF5E8EA);
  static const iconFill = Color(0xFFF3EBED);
  static const shellPadding = 16.0;
  static const cardRadius = 14.0;
  static const cardGap = 10.0;

  static const green = maroon;
  static const greenDark = maroonDark;
  static const sand = canvas;
  static const earth = maroon;
  static const ink = black;

  static ThemeData material() {
    final base = ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.compact,
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
        toolbarHeight: 48,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        iconTheme: IconThemeData(color: maroon, size: 22),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: maroon,
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          visualDensity: VisualDensity.compact,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cream,
        isDense: true,
        labelStyle: const TextStyle(fontSize: 13, color: muted),
        hintStyle: const TextStyle(fontSize: 13, color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE4D9CC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE4D9CC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gold, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: maroon,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(42),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.2, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: maroon,
          side: const BorderSide(color: gold, width: 1),
          minimumSize: const Size.fromHeight(42),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
      chipTheme: const ChipThemeData(
        labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: maroon,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: gold),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: maroonDark,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: maroon,
        unselectedItemColor: muted,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
    );
    try {
      return base.copyWith(
        textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
          displaySmall: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: black, fontSize: 20),
          headlineMedium: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: black, fontSize: 18),
          headlineSmall: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: black, fontSize: 16),
          titleLarge: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: black, fontSize: 16),
          titleMedium: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: black, fontSize: 15),
          titleSmall: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: black, fontSize: 13),
          bodyLarge: GoogleFonts.dmSans(fontWeight: FontWeight.w400, color: black, fontSize: 15),
          bodyMedium: GoogleFonts.dmSans(fontWeight: FontWeight.w400, color: black, fontSize: 14),
          bodySmall: GoogleFonts.dmSans(fontWeight: FontWeight.w400, color: muted, fontSize: 12),
          labelLarge: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: black, fontSize: 13),
        ).apply(bodyColor: black, displayColor: black),
      );
    } catch (_) {
      return base;
    }
  }
}
