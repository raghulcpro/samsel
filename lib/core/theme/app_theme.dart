import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors extracted from your screenshot
  static const Color primaryPink = Color(0xFFE91E63);
  static const Color lightPinkCard = Color(0xFFFCE4EC); // Very light pink for stats
  static const Color darkText = Color(0xFF2D2D2D);
  static const Color greyText = Color(0xFF757575);
  static const Color scaffoldBackground = Colors.white;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: scaffoldBackground,
    primaryColor: primaryPink,
    colorScheme: const ColorScheme.light(
      primary: primaryPink,
      secondary: Color(0xFFFF4081),
      surface: Colors.white,
      onSurface: darkText,
      error: Colors.redAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: darkText,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: darkText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: darkText),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: darkText),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkText),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkText),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: darkText),
      bodyLarge: TextStyle(fontSize: 16, color: darkText),
      bodyMedium: TextStyle(fontSize: 14, color: greyText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPink,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0, // Flat style as per screenshot
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(20),
    ),
  );
}