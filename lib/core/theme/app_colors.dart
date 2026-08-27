import "package:flutter/painting.dart";

/// Palette Carré Magique — design system "Plateau de Nuit".
///
/// Convention : les constantes sans suffixe correspondent au **mode clair**.
/// Les variantes de mode sombre portent le suffixe `Dark`.
class AppColors {
  const AppColors._();

  // ───────────────────────────────────────────────
  // PALETTE SOURCE — tokens bruts du design system
  // ───────────────────────────────────────────────

  static const Color _terreNoire = Color(0xFF16100B);
  static const Color _argileSombre = Color(0xFF271B13);
  static const Color _boueSeche = Color(0xFF3A2E22);
  static const Color _orKola = Color(0xFFD4952B);
  static const Color _argileVive = Color(0xFFC04832);
  static const Color _savane = Color(0xFF3E7237);
  static const Color _sableChaud = Color(0xFFEAD9AF);
  static const Color _laterite = Color(0xFF8A7560);

  // ───────────────────────────────────────────────
  // BRAND — Or kola
  // ───────────────────────────────────────────────

  /// Brand — CTA principal, focus, tab actif (`#D4952B`).
  static const Color primary = _orKola;

  /// État hover (`#E0A44A`).
  static const Color primaryHover = Color(0xFFE0A44A);

  /// État pressé (`#B37C1F`).
  static const Color primaryPressed = Color(0xFFB37C1F);

  /// Fond de chip actif, halo de focus — primary @ 12%.
  static const Color primarySubtle = Color(0x1FD4952B);

  /// Texte sur surface primary (Terre noire pour contraste sur Or kola).
  static const Color onPrimary = _terreNoire;

  // Variantes dark
  static const Color primaryDark = _orKola;
  static const Color primaryHoverDark = Color(0xFFE8B25A);
  static const Color primaryPressedDark = Color(0xFFB37C1F);
  static const Color primarySubtleDark = Color(0x1FD4952B);

  // ───────────────────────────────────────────────
  // ENCRE & SABLE — couleurs de texte de marque
  // ───────────────────────────────────────────────

  /// Terre noire — texte principal en light mode.
  static const Color ink = _terreNoire;
  static const Color ink87 = Color(0xDE16100B);
  static const Color ink54 = Color(0x8A16100B);
  static const Color ink38 = Color(0x6116100B);

  /// Sable chaud — texte principal en dark mode.
  static const Color paleMint = _sableChaud;
  static const Color paleMint87 = Color(0xDEEAD9AF);
  static const Color paleMint70 = Color(0xB3EAD9AF);
  static const Color paleMint54 = Color(0x8AEAD9AF);
  static const Color paleMint38 = Color(0x61EAD9AF);

  // ───────────────────────────────────────────────
  // SURFACES — Mode clair
  // ───────────────────────────────────────────────

  /// Fond scaffold — blanc chaud subtil (`#FBF6EE`).
  static const Color surfacePage = Color(0xFFFBF6EE);

  /// Cards, panneaux, champs (`#F5EDDC`).
  static const Color surfaceCard = Color(0xFFF5EDDC);

  /// Card hover/pressée, en-tête sticky (`#EEE4CE`).
  static const Color surfaceRaised = Color(0xFFEEE4CE);

  /// Zones creuses, preview, quotations (`#E7DBC0`).
  static const Color surfaceSunken = Color(0xFFE7DBC0);

  /// Cards feature, snackbars — surface sombre (Terre noire).
  static const Color surfaceInverse = _terreNoire;

  /// Bottom navigation bar, app bar (`#FBF6EE`).
  static const Color surfaceNav = Color(0xFFFBF6EE);

  // ───────────────────────────────────────────────
  // SURFACES — Mode sombre
  // ───────────────────────────────────────────────

  static const Color surfacePageDark = _terreNoire;
  static const Color surfaceCardDark = _argileSombre;
  static const Color surfaceRaisedDark = Color(0xFF33241A);
  static const Color surfaceSunkenDark = Color(0xFF0F0B07);
  static const Color surfaceInverseDark = _sableChaud;
  static const Color surfaceNavDark = _argileSombre;

  // ───────────────────────────────────────────────
  // TEXTE — Mode clair
  // ───────────────────────────────────────────────

  static const Color textPrimary = _terreNoire;
  static const Color textSecondary = Color(0xFF5A4A3A);
  static const Color textTertiary = _laterite;
  static const Color textDisabled = Color(0xFFC4B69A);
  static const Color textInverse = _sableChaud;

  /// Liens (Or kola).
  static const Color textAccent = _orKola;

  // ───────────────────────────────────────────────
  // TEXTE — Mode sombre
  // ───────────────────────────────────────────────

  static const Color textPrimaryDark = _sableChaud;
  static const Color textSecondaryDark = _laterite;
  static const Color textTertiaryDark = Color(0xFF6B5A45);
  static const Color textDisabledDark = Color(0xFF4A3E30);
  static const Color textInverseDark = _terreNoire;
  static const Color textAccentDark = Color(0xFFE0A44A);

  // ───────────────────────────────────────────────
  // BORDURES — Mode clair
  // ───────────────────────────────────────────────

  static const Color borderHairline = Color(0xFFE5D8B8);
  static const Color borderDefault = Color(0xFFD6C7A2);
  static const Color borderStrong = _terreNoire;
  static const Color borderFocus = _orKola;

  // ───────────────────────────────────────────────
  // BORDURES — Mode sombre
  // ───────────────────────────────────────────────

  static const Color borderHairlineDark = _boueSeche;
  static const Color borderDefaultDark = Color(0xFF4E3D2C);
  static const Color borderStrongDark = _sableChaud;
  static const Color borderFocusDark = _orKola;

  // ───────────────────────────────────────────────
  // SÉMANTIQUE
  // ───────────────────────────────────────────────

  /// Succès, promotion (Savane `#3E7237`).
  static const Color semanticSuccess = _savane;
  static const Color semanticSuccessBg = Color(0x1F3E7237);

  /// Attention, warning (Or kola).
  static const Color semanticWarning = _orKola;
  static const Color semanticWarningBg = Color(0x1FD4952B);

  /// Erreurs, suppression, capture (Argile vive `#C04832`).
  static const Color semanticError = _argileVive;
  static const Color semanticErrorBg = Color(0x1FC04832);

  /// Info — même Or kola que primary.
  static const Color semanticInfo = _orKola;
  static const Color semanticInfoBg = Color(0x1FD4952B);

  /// Badge hors-ligne.
  static const Color semanticOffline = _laterite;

  // ───────────────────────────────────────────────
  // PIONS — spécifique Carré Magique
  // ───────────────────────────────────────────────

  /// Pion blanc (Sable chaud) + halo doré.
  static const Color pionBlanc = _sableChaud;
  static const Color pionBlancGlow = Color(0x66D4952B);

  /// Pion noir (Argile sombre) + bordure Argile vive.
  static const Color pionNoir = _argileSombre;
  static const Color pionNoirBorder = _argileVive;

  // ───────────────────────────────────────────────
  // CASES DU PLATEAU — halos d'état
  // ───────────────────────────────────────────────

  /// Case survolée — Or kola @ 20%.
  static const Color caseHover = Color(0x33D4952B);

  /// Case sélectionnée — Or kola @ 50%.
  static const Color caseSelected = Color(0x80D4952B);

  /// Case de capture possible — Argile vive @ 30%.
  static const Color caseCapture = Color(0x4DC04832);

  /// Case de promotion — Savane pulsée @ 40%.
  static const Color casePromotion = Color(0x663E7237);

  // ───────────────────────────────────────────────
  // OMBRE FLOTTANTE
  // ───────────────────────────────────────────────

  /// La seule ombre autorisée — FAB, bottom sheet, snackbar.
  /// `0 4px 16px rgba(22, 16, 11, 0.12)` — teinte Terre noire.
  static const Color shadowFloating = Color(0x1F16100B);

  /// Halo plateau actif — cohérent avec `--shadow-plateau` du DS.
  /// `0 0 24px rgba(212, 149, 43, 0.15)`.
  static const Color shadowPlateau = Color(0x26D4952B);

  // ───────────────────────────────────────────────
  // OVERLAY — dégradé sombre pour texte sur image
  // ───────────────────────────────────────────────

  /// Overlay dégradé — bottom sheets sur photo, hero overlay.
  /// Seul "gradient" autorisé : un fondu vers Terre noire pour la lisibilité.
  static const heroOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color(0x8016100B), Color(0xFF16100B)],
  );

  // ───────────────────────────────────────────────
  // NEUTRES — échelle terre/latérite
  // ───────────────────────────────────────────────

  static const Color neutral50 = Color(0xFFFBF6EE);
  static const Color neutral100 = Color(0xFFF5EDDC);
  static const Color neutral200 = Color(0xFFE7DBC0);
  static const Color neutral300 = Color(0xFFD6C7A2);
  static const Color neutral400 = Color(0xFFB3A17E);
  static const Color neutral500 = _laterite;
  static const Color neutral600 = Color(0xFF6B5A45);
  static const Color neutral700 = Color(0xFF4E3D2C);
  static const Color neutral800 = _boueSeche;
  static const Color neutral900 = _terreNoire;
}
