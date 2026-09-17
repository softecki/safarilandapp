import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wicom/pamoja/brand.dart';

class PamojaTheme {
  static ThemeData material() {
    final base = ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.compact,
      colorScheme: const ColorScheme.light(
        primary: PamojaBrand.lake,
        onPrimary: Colors.white,
        secondary: PamojaBrand.indigo,
        onSecondary: Colors.white,
        surface: PamojaBrand.white,
        onSurface: PamojaBrand.text,
        error: PamojaBrand.danger,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: PamojaBrand.mist,
      dividerColor: PamojaBrand.border,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: PamojaBrand.indigo,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 52,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PamojaBrand.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PamojaBrand.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PamojaBrand.lake, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PamojaBrand.lake,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PamojaBrand.indigo,
          side: const BorderSide(color: PamojaBrand.lakeActive, width: 1.5),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: PamojaBrand.lake,
        unselectedItemColor: PamojaBrand.muted,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PamojaBrand.night,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    try {
      return base.copyWith(
        textTheme: GoogleFonts.montserratTextTheme(base.textTheme).apply(
          bodyColor: PamojaBrand.text,
          displayColor: PamojaBrand.indigo,
        ),
      );
    } catch (_) {
      return base;
    }
  }
}
