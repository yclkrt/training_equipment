import 'package:flutter/material.dart';

/// Modern karanlık boks teması.
class AppTheme {
  AppTheme._();

  static const background = Color(0xFF0A0D16);
  static const surface = Color(0xFF141927);
  static const surfaceLight = Color(0xFF1D2440);
  static const fightRed = Color(0xFFFF3B47);
  static const fightRedDark = Color(0xFFB81E28);
  static const restGreen = Color(0xFF2FD27D);
  static const gold = Color(0xFFFFC94D);
  static const textPrimary = Color(0xFFF5F7FF);
  static const textSecondary = Color(0xFF9AA3C0);

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: fightRed,
      brightness: Brightness.dark,
      surface: surface,
    );
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: scheme.copyWith(
        primary: fightRed,
        secondary: gold,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: fightRed,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.12),
        thumbColor: Colors.white,
        overlayColor: fightRed.withValues(alpha: 0.2),
      ),
    );
  }
}
