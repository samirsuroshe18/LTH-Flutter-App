// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Central place for all colors used in the application
class AppColors {
  // Text colors
  static const Color textPrimary = Colors.white70;
  static const Color textSecondary = Colors.white60;

  // Background colors
  static const Color appBarBackground = Color(0x33000000); // Black with 20% opacity
  static const Color cardBackground = Color(0x33000000);
  static const Color chipBackground = Color(0x33FFFFFF); // White with 20% opacity
  static const Color avatarBackground = Color(0x33FFFFFF);
  static const Color iconBackgroundLight = Color(0x33FFFFFF);

  // Accent colors
  static const Color accentColor = Color(0xFF3498DB); // Blue accent color
  static const Color divider = Colors.white30;

  // Icon colors
  static const Color iconColor = Colors.white70;

  // Button colors
  static const Color primaryButtonColor = Colors.deepPurple;
  static const Color secondaryButtonColor = Color(0x33673AB7); // Deep Purple with 20% opacity
  static const Color buttonTextColor = Colors.white60;
}