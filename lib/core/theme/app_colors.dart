import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF050505);
  static const Color cardBackground = Color(0xFF121212);
  static const Color surface = Color(0xFF1A1A1A);

  // Primaries
  static const Color primary = Color(0xFF00D2FF);
  static const Color primaryVariant = Color(0xFF00FFF0);
  static const Color accent = Color(0xFF8A2BE2);

  // Feedback
  static const Color success = Color(0xFF00FFA3);
  static const Color danger = Color(0xFFFF3B3B);
  static const Color warning = Color(0xFFFFB800);

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color textTertiary = Color(0xFF606060);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFFC77DFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Colors.white10, Colors.transparent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
