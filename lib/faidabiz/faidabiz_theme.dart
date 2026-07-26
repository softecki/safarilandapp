import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FaidaBizTheme {
  static const green = Color(0xFF15803D);
  static const greenDark = Color(0xFF166534);
  static const black = Color(0xFF111111);
  static const canvas = Color(0xFFF0F7F2); // neumorphic soft green base

  /// Trial = red, expired/unpaid = blue, active/paid = green.
  static Color subscriptionStatusColor(String? status) {
    switch (status) {
      case 'active':
        return green;
      case 'trial':
        return const Color(0xFFDC2626);
      case 'expired':
        return const Color(0xFF2563EB);
      default:
        return Colors.grey.shade700;
    }
  }

  static ThemeData material() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: green,
        primary: green,
        secondary: greenDark,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: black,
      ),
      scaffoldBackgroundColor: canvas,
      appBarTheme: const AppBarTheme(
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: green,
        unselectedItemColor: Color(0xFF666666),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFAFDFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
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
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );

    try {
      return base.copyWith(
        textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(
          bodyColor: black,
          displayColor: black,
        ),
      );
    } catch (_) {
      return base;
    }
  }

  /// Safely coerce API JSON values (num / String / null) to a finite [double].
  static double asDouble(Object? v, [double fallback = 0]) {
    if (v == null) return fallback;
    if (v is num) {
      final d = v.toDouble();
      return d.isFinite ? d : fallback;
    }
    final s = v.toString().trim().replaceAll(',', '');
    if (s.isEmpty) return fallback;
    return double.tryParse(s) ?? fallback;
  }

  static String money(Object? v, {String currency = 'TZS'}) {
    final n = asDouble(v);
    final s = n.round().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return '$s $currency';
  }

  /// Plain integer for amount/price TextFields (no `.00`, no thousand separators).
  static String amountInput(Object? v) {
    return asDouble(v).round().toString();
  }

  /// Quantity / stock for TextFields — whole numbers without `.0` / `.00`.
  static String qtyInput(Object? v) {
    final n = asDouble(v);
    if (n == n.roundToDouble()) return n.round().toString();
    // Rare fractional stock: trim trailing zeros (e.g. 1.50 → 1.5)
    var s = n.toStringAsFixed(4);
    while (s.contains('.') && (s.endsWith('0') || s.endsWith('.'))) {
      s = s.substring(0, s.length - 1);
    }
    return s;
  }
}
