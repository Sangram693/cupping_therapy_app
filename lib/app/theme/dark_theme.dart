import 'package:flutter/material.dart';

import '../../core/services/app_color_service.dart';

ThemeData buildDarkTheme() {
  final baseTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.secondary,
      secondary: AppColors.secondary,
      surface: const Color(0xFF10251D),
      error: AppColors.error,
    ),
  );

  return baseTheme.copyWith(
    scaffoldBackgroundColor: const Color(0xFF081B16),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFF10251D),
      foregroundColor: Color(0xFFEAF7F0),
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF10251D),
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF1E3B32)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF10251D),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF234035)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF234035)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: const TextStyle(color: Color(0xFFEAF7F0)),
      hintStyle: const TextStyle(color: Color(0xFFB7C9C0)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    dividerColor: const Color(0xFF234035),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF10251D),
      indicatorColor: AppColors.secondary.withValues(alpha: 0.16),
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStatePropertyAll(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    textTheme: baseTheme.textTheme.apply(
      bodyColor: const Color(0xFFEAF7F0),
      displayColor: const Color(0xFFEAF7F0),
    ),
  );
}
