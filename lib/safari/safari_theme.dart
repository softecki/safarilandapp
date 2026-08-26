import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SafariTheme {
  static const green = Color(0xFF2F5D3A);
  static const greenDark = Color(0xFF1F3D28);
  static const sand = Color(0xFFF4EFE6);
  static const earth = Color(0xFF8B5E34);
  static const gold = Color(0xFFC4A35A);
  static const ink = Color(0xFF1C1917);
  static const muted = Color(0xFF6B6259);

  static ThemeData material() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: green,
        primary: green,
        secondary: earth,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: ink,
      ),
      scaffoldBackgroundColor: sand,
      appBarTheme: const AppBarTheme(
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: green, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: green,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: green,
        unselectedItemColor: muted,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
    try {
      return base.copyWith(
        textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(bodyColor: ink, displayColor: ink),
      );
    } catch (_) {
      return base;
    }
  }
}
