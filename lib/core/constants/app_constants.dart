import 'package:flutter/material.dart';

enum UserRole {
  superAdmin,
  manager,
  employee,
  none,
}

class AppConstants {
  // --- STRINGS ---
  static const String appTitle = 'SAMSEL'; // Fixed: Added this back

  // --- NEW LIGHT THEME PALETTE ---
  static const Color primaryBgTop = Color(0xFFFDEFF6);
  static const Color primaryBgBottom = Color(0xFFFFFFFF);

  static const Color accentColorLight = Color(0xFFF52F78);
  static const Color accentColorDark = Color(0xFFFF5996);

  static const Color textDark = Color(0xFF555555);
  static const Color textLight = Color(0xFF999999);
  static const Color inputFill = Color(0xFFF2F4F7);

  static const double borderRadius = 20.0;

  // Mock Credentials
  static const String superAdminEmail = 'admin@samsel.com';
  static const String superAdminPassword = 'admin';
  static const String managerEmail = 'manager@samsel.com';
  static const String managerPassword = 'manager';
  static const String employeeEmail = 'employee@samsel.com';
  static const String employeePassword = 'employee';
}