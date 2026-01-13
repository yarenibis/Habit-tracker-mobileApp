import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFFF7F8FA);

  static const yellow = Color(0xFFFFE082);
  static const pink = Color(0xFFF8BBD0);
  static const blue = Color(0xFFBBDEFB);
  static const green = Color(0xFFC8E6C9);
  static const purple = Color(0xFFD1C4E9);
  static const orange = Color(0xFFFFCCBC);

  static const primary = Color(0xFF7EC8E3);
  static const textDark = Color(0xFF333333);
  static const textLight = Color(0xFF777777);

  ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppTheme.background,
  fontFamily: 'SF Pro',

  colorScheme: ColorScheme.light(
    primary: AppTheme.primary,
    secondary: AppTheme.pink,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: AppTheme.textDark,
  ),

  cardTheme: CardTheme(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),

  textTheme: const TextTheme(
    displayMedium: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: AppTheme.textDark,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppTheme.textDark,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: AppTheme.textLight,
    ),
  ),
);

}
