import "package:flutter/material.dart";
import "package:magi_carre/l10n/app_localizations.dart";

import "../theme/app_colors.dart";
import "../theme/app_spacing.dart";

/// Extensions courantes sur `BuildContext`.
///
/// Fournit un accès concis au thème, à la géométrie de l'écran et aux
/// retours utilisateur (snackbars, dialogs) avec le ton magi_carre (tutoiement,
/// phrases courtes, aucune exclamation — cf. `docs/UI_DOC.md` §13).
extension BuildContextExtensions on BuildContext {
  // ═══════════════════════════════════════════════════════════════
  // Localisation
  // ═══════════════════════════════════════════════════════════════

  /// Accès concis aux chaînes traduites. Ex : `context.l10n.commonOk`.
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  // ═══════════════════════════════════════════════════════════════
  // Thème & apparence
  // ═══════════════════════════════════════════════════════════════

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  // ═══════════════════════════════════════════════════════════════
  // Responsive
  // ═══════════════════════════════════════════════════════════════

  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  Orientation get orientation => MediaQuery.orientationOf(this);
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  EdgeInsets get padding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  // ═══════════════════════════════════════════════════════════════
  // Navigation
  // ═══════════════════════════════════════════════════════════════

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  bool get canPop => Navigator.of(this).canPop();

  // ═══════════════════════════════════════════════════════════════
  // Retour utilisateur
  // ═══════════════════════════════════════════════════════════════

  /// Affiche une snackbar sobre. Le style de fond vient du thème
  /// (`surfaceInverse`) ; on peut le remplacer via `backgroundColor`.
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          backgroundColor: backgroundColor,
          action: action,
        ),
      );
  }

  /// Erreur — fond fig (`semanticError`).
  void showError(String message) {
    showSnackBar(
      message,
      backgroundColor: AppColors.semanticError,
      duration: const Duration(seconds: 4),
    );
  }

  /// Succès — fond olive (`semanticSuccess`).
  void showSuccess(String message) {
    showSnackBar(message, backgroundColor: AppColors.semanticSuccess);
  }

  /// Info — fond sky (`semanticInfo`).
  void showInfo(String message) {
    showSnackBar(message, backgroundColor: AppColors.semanticInfo);
  }

  /// Dialog de confirmation — tutoiement, phrases courtes.
  ///
  /// Retourne `true` si l'utilisateur confirme, `false` s'il annule.
  Future<bool?> showConfirmDialog({
    required String title,
    required String content,
    String confirmLabel = "OK",
    String cancelLabel = "Annuler",
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          content,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: context.isDarkMode
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelLabel),
          ),
          AppSpacing.gapHSm,
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: destructive
                ? ElevatedButton.styleFrom(
                    backgroundColor: AppColors.semanticError,
                  )
                : null,
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  /// Dialog informatif — un seul bouton.
  Future<void> showInfoDialog({
    required String title,
    required String content,
    String buttonLabel = "OK",
  }) {
    return showDialog<void>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}
