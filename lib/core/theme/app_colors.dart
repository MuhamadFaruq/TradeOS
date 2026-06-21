import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds - Using a deeper, more professional Slate/Navy palette
  static const Color background = Color(0xFF020617); // Deepest Navy
  static const Color cardBackground = Color(0xFF0F172A); // Slate 900
  static const Color surface = Color(0xFF1E293B); // Slate 800

  // Primaries - Refined Emerald/Teal for a FinTech look
  static const Color primary = Color(0xFF10B981); // Emerald 500
  static const Color primaryVariant = Color(0xFF059669); // Emerald 600
  static const Color accent = Color(0xFF6366F1); // Indigo 500 (Sophisticated contrast)

  // Feedback - More balanced colors
  static const Color success = Color(0xFF34D399); // Soft Emerald
  static const Color danger = Color(0xFFFB7185);  // Rose 400 (More modern than pure red)
  static const Color warning = Color(0xFFFBBF24); // Amber 400

  // Text - High contrast for readability
  static const Color textPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color textSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color textTertiary = Color(0xFF64748B); // Slate 500

  // Gradients - More subtle, less "Neon"
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF0EA5E9)], // Emerald to Sky Blue
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFF8B5CF6)], // Indigo to Violet
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x0DFFFFFF), Colors.transparent], // 5% White to Transparent
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
