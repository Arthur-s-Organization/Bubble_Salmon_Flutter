import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      // Définition des couleurs
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFFE6F61),
        onPrimary: Colors.white,
        secondary: Color(0xFF6FCF97),
        onSecondary: Colors.white,
        tertiary: Color(0xFF380010),
        tertiaryContainer: Color(0xFF1D0010),
        surface: Colors.white,
        onSurface: Colors.black,
        error: Colors.red,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: Color(0xFF380010),
    );
  }
}
