import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../configs/app_config.dart";
import "app_colors.dart";
import "app_spacing.dart";
import "app_text_styles.dart";

class AppTheme {
  const AppTheme._();

  // ─────────────────────────────────────────────
  // FONTS
  // ─────────────────────────────────────────────

  static final String fontFamily = AppConfig.instance.fontFamily;

  // ─────────────────────────────────────────────
  // SHAPES
  // ─────────────────────────────────────────────

  static const shapeLarge = RoundedRectangleBorder(
    borderRadius: AppSpacing.roundedXl, // 16 — cards, dialogs, bottom sheets
  );
  static const shapeMedium = RoundedRectangleBorder(
    borderRadius: AppSpacing.roundedLg, // 12 — boutons, inputs
  );
  static const shapeSmall = RoundedRectangleBorder(
    borderRadius: AppSpacing.roundedMd, // 8 — chips, snackbars
  );

  // -----------------------------------------------------------------------
  // COULEURS (ColorScheme)
  // -----------------------------------------------------------------------
  // Light : fond pêche, CTA vert profond, accent vert vif.
  // Dark  : fond noir, CTA vert vif, accent pêche.
  // -----------------------------------------------------------------------
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primarySubtle,
    onPrimaryContainer: AppColors.primaryPressed,
    secondary: AppColors.primaryHover,
    onSecondary: AppColors.onPrimary,
    tertiary: AppColors.semanticInfo,
    onTertiary: AppColors.onPrimary,
    error: AppColors.semanticError,
    onError: AppColors.textInverse,
    surface: AppColors.surfacePage,
    onSurface: AppColors.ink,
    surfaceContainer: AppColors.surfaceCard,
    onSurfaceVariant: AppColors.ink54,
    outline: AppColors.neutral300,
    outlineVariant: AppColors.borderHairline,
    inverseSurface: AppColors.surfaceInverse,
    onInverseSurface: AppColors.textInverse,
    inversePrimary: AppColors.primaryHover,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    onPrimary: AppColors.ink,
    primaryContainer: AppColors.primarySubtleDark,
    onPrimaryContainer: AppColors.primaryHoverDark,
    secondary: AppColors.primary,
    onSecondary: AppColors.paleMint,
    tertiary: AppColors.primary,
    onTertiary: AppColors.paleMint,
    error: AppColors.semanticError,
    onError: AppColors.paleMint,
    surface: AppColors.surfacePageDark,
    onSurface: AppColors.paleMint,
    surfaceContainer: AppColors.surfaceCardDark,
    onSurfaceVariant: AppColors.paleMint54,
    outline: AppColors.neutral600,
    outlineVariant: AppColors.borderHairlineDark,
    inverseSurface: AppColors.surfaceInverseDark,
    onInverseSurface: AppColors.textInverseDark,
    inversePrimary: AppColors.primary,
  );

  // ─────────────────────────────────────────────
  // TEXT THEMES
  // ─────────────────────────────────────────────

  static final TextTheme _lightTextTheme = AppTextStyles.lightTextTheme.apply(
    bodyColor: lightColorScheme.onSurface,
    displayColor: lightColorScheme.onSurface,
  );

  static final TextTheme _darkTextTheme = AppTextStyles.darkTextTheme.apply(
    bodyColor: darkColorScheme.onSurface,
    displayColor: darkColorScheme.onSurface,
  );

  // Standalone styles
  static const TextStyle _buttonText = AppTextStyles.buttonText;
  static const TextStyle _inputText = AppTextStyles.inputText;
  static const TextStyle _inputLabel = AppTextStyles.inputLabel;
  static const TextStyle _appBarTitle = AppTextStyles.appBarTitle;

  // ─────────────────────────────────────────────
  // LIGHT THEME
  // ─────────────────────────────────────────────

  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    brightness: Brightness.light,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.surface,
    canvasColor: lightColorScheme.surface,

    textTheme: _lightTextTheme,

    // ─── AppBar ─────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface,
      foregroundColor: lightColorScheme.onSurface,
      elevation: AppSpacing.elevationNone,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      toolbarHeight: AppSpacing.appBarHeight,
      titleTextStyle: _appBarTitle.copyWith(color: lightColorScheme.onSurface),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    // ─── Buttons ────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        elevation: AppSpacing.elevationSm,
        shadowColor: AppColors.shadowFloating,
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: shapeMedium,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        textStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightColorScheme.onSurface,
        side: BorderSide(color: lightColorScheme.outline),
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: shapeMedium,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        textStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightColorScheme.primary,
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: shapeSmall,
        textStyle: _buttonText,
      ),
    ),

    // ─── Input Decoration (TextField) ───────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightColorScheme.surfaceContainer,
      contentPadding: AppSpacing.inputPadding,
      border: const OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide(
          color: lightColorScheme.primary,
          width: AppSpacing.borderWidthThick,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide(
          color: lightColorScheme.error,
          width: AppSpacing.borderWidthMedium,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide(
          color: lightColorScheme.error,
          width: AppSpacing.borderWidthThick,
        ),
      ),
      labelStyle: _inputLabel.copyWith(
        color: lightColorScheme.onSurfaceVariant,
      ),
      hintStyle: _inputText.copyWith(color: AppColors.neutral500),
    ),

    // ─── Card ───────────────────────────────────────
    cardTheme: CardThemeData(
      color: lightColorScheme.surfaceContainer,
      elevation: AppSpacing.elevationNone,
      shape: shapeLarge,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shadowColor: AppColors.shadowFloating,
      surfaceTintColor: Colors.transparent,
    ),

    // ─── FloatingActionButton ───────────────────────
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      elevation: AppSpacing.elevationSm,
      shape: const CircleBorder(),
    ),

    // ─── Bottom Navigation Bar ──────────────────────
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: lightColorScheme.surface,
      elevation: AppSpacing.elevationXs,
      selectedItemColor: lightColorScheme.primary,
      unselectedItemColor: lightColorScheme.onSurface.withAlpha(127),
      selectedLabelStyle: _lightTextTheme.labelMedium,
      unselectedLabelStyle: _lightTextTheme.labelSmall,
    ),

    // ─── Dialog ─────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: lightColorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: shapeMedium,
      titleTextStyle: _lightTextTheme.titleLarge,
      contentTextStyle: _lightTextTheme.bodyMedium,
    ),

    // ─── Bottom sheet ───────────────────────────────
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: lightColorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: AppSpacing.elevationNone,
      shape: const RoundedRectangleBorder(
        borderRadius: AppSpacing.roundedTopXl,
      ),
    ),

    // ─── SnackBar ───────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: lightColorScheme.inverseSurface,
      contentTextStyle: _lightTextTheme.bodyMedium?.copyWith(
        color: lightColorScheme.onInverseSurface,
      ),
      behavior: SnackBarBehavior.floating,
      shape: shapeSmall,
    ),

    // ─── Chip ───────────────────────────────────────
    chipTheme: ChipThemeData(
      selectedColor: lightColorScheme.primary.withAlpha(25),
      secondarySelectedColor: lightColorScheme.secondary.withAlpha(25),
      labelStyle: _lightTextTheme.labelMedium,
      shape: shapeSmall,
      side: BorderSide(color: lightColorScheme.outline),
    ),

    // ─── Icon ───────────────────────────────────────
    iconTheme: IconThemeData(
      color: lightColorScheme.primary,
      size: AppSpacing.iconLg,
    ),

    // ─── Progress ───────────────────────────────────
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: lightColorScheme.primary,
      circularTrackColor: AppColors.neutral200,
    ),

    // ─── Divider ────────────────────────────────────
    dividerTheme: DividerThemeData(
      color: lightColorScheme.outlineVariant,
      thickness: AppSpacing.dividerThickness,
      space: AppSpacing.dividerThickness,
    ),

    // ─── Switch ─────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.onPrimary;
        }
        return AppColors.neutral400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.primary;
        }
        return Colors.transparent;
      }),
    ),

    // ─── Checkbox ───────────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(lightColorScheme.onPrimary),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
    ),

    // ─── Radio ──────────────────────────────────────
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.primary;
        }
        return AppColors.neutral400;
      }),
    ),
  );

  // ─────────────────────────────────────────────
  // DARK THEME
  // ─────────────────────────────────────────────

  static final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkColorScheme.surface,
    canvasColor: darkColorScheme.surface,

    textTheme: _darkTextTheme,

    // ─── AppBar ─────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onSurface,
      elevation: AppSpacing.elevationNone,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      toolbarHeight: AppSpacing.appBarHeight,
      titleTextStyle: _appBarTitle.copyWith(color: darkColorScheme.onSurface),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    // ─── Buttons ────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        elevation: AppSpacing.elevationSm,
        shadowColor: Colors.black.withAlpha(102),
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: shapeMedium,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        textStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkColorScheme.onSurface,
        side: BorderSide(color: darkColorScheme.outline),
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: shapeMedium,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        textStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkColorScheme.secondary,
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: shapeSmall,
        textStyle: _buttonText,
      ),
    ),

    // ─── Input Decoration (TextField) ───────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkColorScheme.surfaceContainer,
      contentPadding: AppSpacing.inputPadding,
      border: const OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide(
          color: darkColorScheme.primary,
          width: AppSpacing.borderWidthThick,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide(
          color: darkColorScheme.error,
          width: AppSpacing.borderWidthMedium,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedLg,
        borderSide: BorderSide(
          color: darkColorScheme.error,
          width: AppSpacing.borderWidthThick,
        ),
      ),
      labelStyle: _inputLabel.copyWith(color: AppColors.paleMint70),
      hintStyle: _inputText.copyWith(color: AppColors.paleMint38),
    ),

    // ─── Card ───────────────────────────────────────
    cardTheme: CardThemeData(
      color: darkColorScheme.surfaceContainer,
      elevation: AppSpacing.elevationNone,
      shape: shapeLarge,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shadowColor: Colors.black.withAlpha(51),
      surfaceTintColor: Colors.transparent,
    ),

    // ─── FloatingActionButton ───────────────────────
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
      elevation: AppSpacing.elevationSm,
      shape: const CircleBorder(),
    ),

    // ─── Bottom Navigation Bar ──────────────────────
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: darkColorScheme.surface,
      elevation: AppSpacing.elevationXs,
      selectedItemColor: darkColorScheme.primary,
      unselectedItemColor: AppColors.paleMint.withAlpha(127),
      selectedLabelStyle: _darkTextTheme.labelMedium,
      unselectedLabelStyle: _darkTextTheme.labelSmall,
    ),

    // ─── Dialog ─────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: darkColorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: shapeMedium,
      titleTextStyle: _darkTextTheme.titleLarge,
      contentTextStyle: _darkTextTheme.bodyMedium,
    ),

    // ─── Bottom sheet ───────────────────────────────
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: darkColorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: AppSpacing.elevationNone,
      shape: const RoundedRectangleBorder(
        borderRadius: AppSpacing.roundedTopXl,
      ),
    ),

    // ─── SnackBar ───────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: darkColorScheme.inverseSurface,
      contentTextStyle: _darkTextTheme.bodyMedium?.copyWith(
        color: darkColorScheme.onInverseSurface,
      ),
      behavior: SnackBarBehavior.floating,
      shape: shapeSmall,
    ),

    // ─── Chip ───────────────────────────────────────
    chipTheme: ChipThemeData(
      selectedColor: darkColorScheme.primary.withAlpha(25),
      secondarySelectedColor: darkColorScheme.secondary.withAlpha(25),
      labelStyle: _darkTextTheme.labelMedium,
      shape: shapeSmall,
      side: BorderSide(color: darkColorScheme.outline),
    ),

    // ─── Icon ───────────────────────────────────────
    iconTheme: const IconThemeData(
      color: AppColors.paleMint,
      size: AppSpacing.iconLg,
    ),

    // ─── Progress ───────────────────────────────────
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: darkColorScheme.primary,
      circularTrackColor: AppColors.surfaceCardDark,
    ),

    // ─── Divider ────────────────────────────────────
    dividerTheme: DividerThemeData(
      color: darkColorScheme.outlineVariant,
      thickness: AppSpacing.dividerThickness,
      space: AppSpacing.dividerThickness,
    ),

    // ─── Switch ─────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return darkColorScheme.onPrimary;
        }
        return AppColors.paleMint54;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return darkColorScheme.primary;
        }
        return Colors.transparent;
      }),
    ),

    // ─── Checkbox ───────────────────────────────────
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return darkColorScheme.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(darkColorScheme.onPrimary),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
    ),

    // ─── Radio ──────────────────────────────────────
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return darkColorScheme.primary;
        }
        return AppColors.paleMint54;
      }),
    ),
  );
}
