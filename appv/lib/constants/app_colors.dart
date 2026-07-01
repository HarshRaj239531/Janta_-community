import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // Premium Gold Palette
  static const Color goldStart = Color(0xFFF3C66F);
  static const Color goldMiddle = Color(0xFFFCE7B2);
  static const Color goldAccent = Color(0xFFDCA134);
  static const Color goldEnd = Color(0xFFB9801C);

  // Metallic Gold Gradient
  static const List<Color> goldGradient = [
    goldStart,
    goldMiddle,
    goldAccent,
    goldEnd,
    goldStart,
  ];

  // Theme Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color textDark = Color(0xFF1E2022);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color emeraldGreen = Color(0xFF0F9B5E);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color shadowColor = Color(0x1F000000);
}
