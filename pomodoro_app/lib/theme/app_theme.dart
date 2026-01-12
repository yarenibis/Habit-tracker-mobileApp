import 'package:flutter/material.dart';

class AppTheme {
  // Daha yumuşak, pastel tonlar
  static const Color background = Color(0xFFFDFCFB); // Çok hafif krem-beyaz
  static const Color primary = Color(0xFF8FA3FF); // Daha yumuşak mavi
  static const Color secondary = Color(0xFFD5DEFF); // Pastel mavi
  static const Color textPrimary = Color(0xFF374151); // Daha açık gri
  static const Color textSecondary = Color(0xFF9CA3AF); // Daha yumuşak gri
  static const Color card = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFFFFB5E8); // Pastel pembe aksan rengi

  // Yumuşak gölgeler için renkler
  static const Color softShadow = Color(0x1A6B7280);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      background: background,
      surface: card,
      surfaceVariant: Color(0xFFF5F5F5),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500, // Bold yerine medium
        letterSpacing: -0.3, // Harf aralığını daralttık
      ),
      iconTheme: IconThemeData(
        color: textPrimary,
        size: 22,
      ),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w300, // Light weight
        fontSize: 32,
      ),
      displayMedium: TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w400, // Regular
        fontSize: 28,
      ),
      titleLarge: TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w500, // Medium
        fontSize: 22,
        letterSpacing: -0.2,
      ),
      titleMedium: TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
      bodyLarge: TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.5, // Satır yüksekliği
      ),
      bodyMedium: TextStyle(
        color: textSecondary,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.6,
      ),
      labelLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    ),

    cardTheme: CardTheme(
      color: card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24), // Daha yuvarlak köşeler
      ),
      surfaceTintColor: Colors.transparent,
      shadowColor: softShadow,
      margin: const EdgeInsets.all(8),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 1,
      highlightElevation: 0,
    ),

    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primary.withOpacity(0.9); // Hafif saydamlık
        }
        return null;
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
      side: BorderSide(
        color: textSecondary.withOpacity(0.3), // Daha soft border
        width: 1.5,
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: textSecondary,
      elevation: 0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
    ),

    // Yumuşak butonlar
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    // Yumuşak text field'lar
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: primary,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: textSecondary.withOpacity(0.1),
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      hintStyle: TextStyle(
        color: textSecondary.withOpacity(0.6),
        fontWeight: FontWeight.w400,
      ),
      labelStyle: const TextStyle(
        color: textSecondary,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Yumuşak divider
    dividerTheme: DividerThemeData(
      color: textSecondary.withOpacity(0.1),
      thickness: 1,
      space: 0,
    ),

    // Yumuşak list tile'lar
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    ),

    // Yumuşak progress indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
      linearTrackColor: Color(0xFFE5E7EB),
    ),

    // Yumuşak chip'ler
    chipTheme: ChipThemeData(
      backgroundColor: textSecondary.withOpacity(0.08),
      selectedColor: primary.withOpacity(0.15),
      labelStyle: const TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w400,
      ),
      secondaryLabelStyle: const TextStyle(
        color: primary,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
