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
      
      // Global Page Transition Animations
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        },
      ),

      // Modern Styled Buttons with animations
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: AppColors.primaryGreen.withAlpha(51),
          splashFactory: InkSparkle.splashFactory, // Modern Android/iOS sparkle tap feedback
        ),
      ),

      // Modern text inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
      ),
    );
  }
}
