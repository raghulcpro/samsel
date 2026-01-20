import 'package:flutter/material.dart';
import 'package:sammsel/core/constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppConstants.accentColorLight,
      scaffoldBackgroundColor: Colors.white,

      // Define the Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppConstants.accentColorLight,
        secondary: AppConstants.accentColorDark,
        surface: Colors.white,
        onSurface: AppConstants.textDark,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppConstants.textDark),
        titleTextStyle: TextStyle(
          color: AppConstants.textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Input Decoration Theme (Matches your login fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppConstants.accentColorLight, width: 2),
        ),
      ),
    );
  }
}