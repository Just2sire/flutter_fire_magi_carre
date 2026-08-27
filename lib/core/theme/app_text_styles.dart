import "package:flutter/material.dart" show TextTheme, FontWeight, TextStyle;

import "app_colors.dart";

/// Typographie Carré Magique — 4 familles rôle-par-rôle.
///
/// - **Unbounded** : display uniquement (titre app, score en partie).
/// - **Syne** : headlines, titles, labels UI (boutons, chips, nav).
/// - **Literata** : body, règles, descriptions, glossaire (lecture longue).
/// - **JetBrainsMono** : notation de coups, coordonnées, arbitrage.
class AppTextStyles {
  const AppTextStyles._();

  // ─────────────────────────────────────────────
  // FAMILLES
  // ─────────────────────────────────────────────

  static const String fontDisplay = "Unbounded";
  static const String fontHeading = "Syne";
  static const String fontBody = "Literata";
  static const String fontMono = "JetBrainsMono";

  /// Alias legacy — pointe vers la famille par défaut (Syne).
  static const String fontFamily = fontHeading;

  // ─────────────────────────────────────────────
  // LIGHT MODE — Text theme
  // ─────────────────────────────────────────────

  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontDisplay,
      fontSize: 48,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.88, // 0.06em @ 48px
      height: 1.2,
      color: AppColors.ink,
    ),
    displayMedium: TextStyle(
      fontFamily: fontDisplay,
      fontSize: 40,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.4,
      height: 1.2,
      color: AppColors.ink,
    ),
    displaySmall: TextStyle(
      fontFamily: fontDisplay,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.92,
      height: 1.2,
      color: AppColors.ink,
    ),
    headlineLarge: TextStyle(
      fontFamily: fontHeading,
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: AppColors.ink,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontHeading,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: AppColors.ink,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontHeading,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: AppColors.ink,
    ),
    titleLarge: TextStyle(
      fontFamily: fontHeading,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.ink,
    ),
    titleMedium: TextStyle(
      fontFamily: fontHeading,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.ink,
    ),
    titleSmall: TextStyle(
      fontFamily: fontHeading,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.ink,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontBody,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1.7,
      color: AppColors.ink87,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontBody,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.7,
      color: AppColors.ink87,
    ),
    bodySmall: TextStyle(
      fontFamily: fontBody,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: AppColors.ink54,
    ),
    labelLarge: TextStyle(
      fontFamily: fontHeading,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.4, // 0.1em @ 14px
      color: AppColors.ink87,
    ),
    labelMedium: TextStyle(
      fontFamily: fontHeading,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: AppColors.ink87,
    ),
    labelSmall: TextStyle(
      fontFamily: fontHeading,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.1,
      color: AppColors.ink87,
    ),
  );

  // ─────────────────────────────────────────────
  // DARK MODE — Text theme
  // ─────────────────────────────────────────────

  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontDisplay,
      fontSize: 48,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.88,
      height: 1.2,
      color: AppColors.paleMint,
    ),
    displayMedium: TextStyle(
      fontFamily: fontDisplay,
      fontSize: 40,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.4,
      height: 1.2,
      color: AppColors.paleMint,
    ),
    displaySmall: TextStyle(
      fontFamily: fontDisplay,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.92,
      height: 1.2,
      color: AppColors.paleMint,
    ),
    headlineLarge: TextStyle(
      fontFamily: fontHeading,
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: AppColors.paleMint,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontHeading,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: AppColors.paleMint,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontHeading,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: AppColors.paleMint,
    ),
    titleLarge: TextStyle(
      fontFamily: fontHeading,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.paleMint,
    ),
    titleMedium: TextStyle(
      fontFamily: fontHeading,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.paleMint,
    ),
    titleSmall: TextStyle(
      fontFamily: fontHeading,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.paleMint,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontBody,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1.7,
      color: AppColors.paleMint87,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontBody,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.7,
      color: AppColors.paleMint87,
    ),
    bodySmall: TextStyle(
      fontFamily: fontBody,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: AppColors.paleMint54,
    ),
    labelLarge: TextStyle(
      fontFamily: fontHeading,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.4,
      color: AppColors.paleMint87,
    ),
    labelMedium: TextStyle(
      fontFamily: fontHeading,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: AppColors.paleMint87,
    ),
    labelSmall: TextStyle(
      fontFamily: fontHeading,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.1,
      color: AppColors.paleMint70,
    ),
  );

  // ─────────────────────────────────────────────
  // STYLES STANDALONE
  // ─────────────────────────────────────────────

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: fontHeading,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontHeading,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
  );

  static const TextStyle inputText = TextStyle(
    fontFamily: fontBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: fontHeading,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  /// Notation de coups, coordonnées, arbitrage.
  static const TextStyle mono = TextStyle(
    fontFamily: fontMono,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
}
