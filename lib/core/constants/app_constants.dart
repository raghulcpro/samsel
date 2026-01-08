import 'package:flutter/material.dart';

enum UserRole {
  superAdmin,
  manager,
  employee,
  none, // For unauthenticated users
}

class AppConstants {
  static const Color primaryBackgroundColorDark = Color(0xFF0F0F14);
  static const Color secondaryBackgroundColorDark = Color(0xFF1A1A22);
  static const Color accentColorLight = Color(0xFFE91E63); // Magenta
  static const Color accentColorDark = Color(0xFFFF6FAE); // Pink
  static const Color glassmorphismOverlayColor = Colors.white; // For the frosted glass effect

  static const double borderRadius = 20.0; // Consistent rounded corners
  static const double cardBlurSigma = 10.0; // For BackdropFilter blur
  static const double cardOpacity = 0.2; // For BackdropFilter opacity

  // Mock Credentials
  static const String superAdminEmail = 'admin@samsel.com';
  static const String superAdminPassword = 'admin';

  static const String managerEmail = 'manager@samsel.com';
  static const String managerPassword = 'manager';

  static const String employeeEmail = 'employee@samsel.com';
  static const String employeePassword = 'employee';

  static const String appTitle = 'SAMSEL';
  static const String appSubtitle = 'Publication Management System';
}
