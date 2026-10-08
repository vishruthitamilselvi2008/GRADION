import 'package:flutter/material.dart';

class AppColors {
  // Primary Agri-tech Greens
  static const Color primaryDark = Color(0xFF0F3E2E);
  static const Color primary = Color(0xFF14533C);
  static const Color primaryLight = Color(0xFF1B6B4E);
  static const Color primarySurface = Color(0xFFEAF5EF);

  // Background & Neutral Colors
  static const Color background = Color(0xFFF6F8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF0F3EE);
  static const Color border = Color(0xFFE2E7DF);
  static const Color borderLight = Color(0xFFEDF1EA);

  // Text Colors
  static const Color textPrimary = Color(0xFF15221B);
  static const Color textSecondary = Color(0xFF5A6E62);
  static const Color textMuted = Color(0xFF8C9E93);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Grade Colors (Strictly according to requirements)
  // Grade A: Emerald Green
  static const Color gradeA = Color(0xFF16A34A);
  static const Color gradeABackground = Color(0xFFE8F8EE);
  static const Color gradeABorder = Color(0xFF86EFAC);

  // Grade B: Warm Yellow / Orange
  static const Color gradeB = Color(0xFFF59E0B);
  static const Color gradeBBackground = Color(0xFFFFFBEB);
  static const Color gradeBBorder = Color(0xFFFCD34D);

  // Grade C: Red
  static const Color gradeC = Color(0xFFDC2626);
  static const Color gradeCBackground = Color(0xFFFEF2F2);
  static const Color gradeCBorder = Color(0xFFFCA5A5);

  // Earthy Onion Accent Tones
  static const Color onionRed = Color(0xFF991B1B);
  static const Color onionSkin = Color(0xFFC2410C);
  static const Color onionGold = Color(0xFFD97706);
  static const Color onionPurple = Color(0xFF831843);
  static const Color onionFlesh = Color(0xFFFDF2F8);

  // Accents
  static const Color accentCyan = Color(0xFF0891B2);
  static const Color accentBlue = Color(0xFF2563EB);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textInverse,
        primaryContainer: AppColors.primarySurface,
        onPrimaryContainer: AppColors.primaryDark,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.gradeC,
        onError: AppColors.textInverse,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textInverse,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
