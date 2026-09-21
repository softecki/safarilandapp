import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SafariTheme {
  static const wine = Color(0xFF761113);
  static const darkEarth = Color(0xFF592D1D);
  static const gold = Color(0xFFD2A84F);
  static const goldSoft = Color(0xFFE8D5A3);
  static const cream = Color(0xFFFBF7F1);
  static const sand = Color(0xFFF2E6D8);
  static const earth = Color(0xFFB4703C);
  static const black = Color(0xFF1A1412);
  static const muted = Color(0xFF7A7066);
  static const cardBorder = Color(0xFFE8DCCB);
  static const canvas = cream;
  static const maroon = wine;
  static const maroonDark = darkEarth;
  static const statFill = sand;
  static const altFill = sand;
  static const pillFill = Color(0xFFF5E8EA);
  static const iconFill = sand;
  static const shellPadding = 16.0;
  static const cardRadius = 18.0;
  static const cardGap = 12.0;
  static const contentMaxWidth = 560.0;
  static const motion = Duration(milliseconds: 220);
  static const minTap = 48.0;

  static const green = wine;
  static const greenDark = darkEarth;
  static const ink = black;

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [wine, darkEarth],
  );

  static List<BoxShadow> get quietShadow => [
        BoxShadow(color: darkEarth.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3)),
      ];

  static TextStyle display({Color color = black, double size = 28, FontWeight weight = FontWeight.w600}) {
    try {
      return GoogleFonts.cormorantGaramond(
        color: color,
        fontSize: size,
        fontWeight: weight,
        height: 1.15,
        letterSpacing: 0.2,
      );
    } catch (_) {
      return TextStyle(color: color, fontSize: size, fontWeight: weight, height: 1.15);
    }
  }

  static ThemeData material() {
    final base = ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      colorScheme: const ColorScheme.light(
        primary: wine,
        onPrimary: Colors.white,
        secondary: gold,
        onSecondary: darkEarth,
        surface: cream,
        onSurface: black,
        error: Color(0xFFB3261E),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: canvas,
      dividerColor: cardBorder,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: wine,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 52,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: display(size: 22, weight: FontWeight.w600),
        iconTheme: const IconThemeData(color: wine, size: 22),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: wine,
          minimumSize: const Size(44, 44),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        isDense: false,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(fontSize: 13, color: muted),
        hintStyle: const TextStyle(fontSize: 14, color: muted),
        errorStyle: const TextStyle(fontSize: 12, height: 1.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: wine, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFB3261E)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: wine,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.2, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: wine,
          side: const BorderSide(color: gold, width: 1.2),
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
        ),
      ),
      chipTheme: const ChipThemeData(
        labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        backgroundColor: sand,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: wine,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: CircleBorder(),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: gold),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkEarth,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: wine,
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
        textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
          displaySmall: display(size: 28),
          headlineMedium: display(size: 24),
          headlineSmall: display(size: 20),
          titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, color: black, fontSize: 17),
          titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w600, color: black, fontSize: 15),
          titleSmall: GoogleFonts.inter(fontWeight: FontWeight.w600, color: black, fontSize: 13),
          bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.w400, color: black, fontSize: 15),
          bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.w400, color: black, fontSize: 14),
          bodySmall: GoogleFonts.inter(fontWeight: FontWeight.w400, color: muted, fontSize: 12),
          labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, color: black, fontSize: 13),
        ).apply(bodyColor: black, displayColor: black),
      );
    } catch (_) {
      return base;
    }
  }
}
