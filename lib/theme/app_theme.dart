import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // THEME CLAIR
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

    iconTheme: const IconThemeData(color: AppColors.textDark),
  );

  // THEME SOMBRE
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.blueNight,

    primaryColor: AppColors.bluePastel,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.bluePastel,
      secondary: AppColors.blueTeal,
      background: AppColors.blueNight,
      surface: Color(0xFF1A1A22),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),

    iconTheme: const IconThemeData(color: Colors.white),
  );
}
