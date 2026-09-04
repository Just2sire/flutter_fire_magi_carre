import "package:dicebear_core/dicebear_core.dart";
import "package:dicebear_styles/adventurer.dart";
import "package:dicebear_styles/bottts.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

/// Style DiceBear à utiliser pour générer l'avatar.
enum DiceBearStyle {
  /// Personnages illustrés — joueurs humains (seed = username).
  adventurer,

  /// Robots — bots IA (seed = nom du bot).
  bottts,
}

/// Avatar vectoriel généré par DiceBear — déterministe, toujours disponible,
/// même hors ligne. Idéal pour les joueurs sans photo de profil et les bots.
///
/// Le [seed] détermine l'apparence : même seed → même avatar sur tous les
/// appareils.
class AppDiceBearAvatar extends StatelessWidget {
  const AppDiceBearAvatar({
    required this.seed,
    super.key,
    this.size = 40.0,
    this.style = DiceBearStyle.adventurer,
    this.clipToCircle = true,
  });

  /// Graine déterministe : username pour les joueurs, nom du bot pour les IA.
  final String seed;

  /// Taille en pixels logiques (largeur et hauteur).
  final double size;

  /// Style graphique à utiliser.
  final DiceBearStyle style;

  /// Si `true`, découpe le rendu dans un cercle.
  final bool clipToCircle;

  // ── Cache statique ─────────────────────────────────────────────────────────
  static Style? _adventurerStyle;
  static Style? _botttsStyle;

  // SVG string cache keyed by "<styleIndex>:<seed>:<sizePx>" to avoid
  // regenerating the same avatar on every hot-rebuild.
  static final Map<String, String> _svgCache = {};

  static Style _resolveStyle(DiceBearStyle s) {
    switch (s) {
      case DiceBearStyle.adventurer:
        return _adventurerStyle ??= Style.parse(adventurer);
      case DiceBearStyle.bottts:
        return _botttsStyle ??= Style.parse(bottts);
    }
  }

  /// Pre-parses both avatar styles so the first lobby render is instant.
  /// Safe to call multiple times — subsequent calls are no-ops.
  static void prewarmStyles() {
    _resolveStyle(DiceBearStyle.bottts);
    _resolveStyle(DiceBearStyle.adventurer);
  }

  @override
  Widget build(BuildContext context) {
    final parsedStyle = _resolveStyle(style);
    final cacheKey = "${style.index}:$seed:${size.round()}";
    final svgString = _svgCache.putIfAbsent(cacheKey, () {
      return Avatar(parsedStyle, {"seed": seed, "size": size.round()}).svg;
    });

    final svg = SvgPicture.string(
      svgString,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );

    if (!clipToCircle) return svg;

    return ClipOval(
      child: SizedBox.square(dimension: size, child: svg),
    );
  }
}
