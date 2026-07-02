import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: AppColors.goldAccent,
            brightness: Brightness.light,
          ).copyWith(
            primary: AppColors.primaryGreen,
            secondary: AppColors.accentMint,
            surface: Colors.white,
            onPrimary: Colors.white,
            onSurface: AppColors.textPrimary,
            onSurfaceVariant: AppColors.textSecondary,
          ),
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundSoft,
    );
  }
}
