import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.background,

    primaryColor: AppColors.primary,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.blueNight,
      background: AppColors.background,
      surface: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.textDark,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.textDark),
      bodyLarge: TextStyle(color: AppColors.textDark),
      titleLarge: TextStyle(
        color: AppColors.textDark,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
