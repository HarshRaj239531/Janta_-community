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

  // Centralized App Theme Colors
  static const Color primaryGreen = Color(0xFF0F4C3A);
  static const Color accentMint = Color(0xFF92D7B1);
  static const Color backgroundSoft = Color(0xFFF3F5F8);
  static const Color backgroundAlt = Color(0xFFF8FAFC);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderMuted = Color(0xFFE5E7EB);
  static const Color lavenderSoft = Color(0xFFEEF2FA);
  static const Color lightGreenTint = Color(0xFFF1F6F3);
  static const Color pillGreenBackground = Color(0xFFE6F0EA);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color errorAccent = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF10B981);
  static const Color primaryDark = Color(0xFF0A3427);
  static const Color accentBlue = Color(0xFFBFDBFE);
  static const Color warningAmber = Color(0xFFFBBF24);
  static const Color infoBlue = Color(0xFF3B82F6);
  static const Color successDark = Color(0xFF065F46);
  static const Color infoBlueDark = Color(0xFF1E40AF);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color errorDark = Color(0xFF991B1B);
  static const Color infoBlueLight = Color(0xFFDBEAFE);
  static const Color containerBgSoft = Color(0xFFF3F5FC);
  static const Color errorBorder = Color(0xFFFCA5A5);
  static const Color timelineMuted = Color(0xFFCBD5E1);
  static const Color successBgSoft = Color(0xFFF1F6F3);
  static const Color mintLight = Color(0xFFE2ECE7);
  static const Color infoBorder = Color(0xFFD0DDF7);
}
