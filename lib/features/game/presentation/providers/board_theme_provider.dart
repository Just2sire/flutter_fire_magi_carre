import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/storage_providers.dart";

part "board_theme_provider.g.dart";

// ─── Data class ─────────────────────────────────────────────────────────────

/// Complete visual theme for the ClassicGameBoard.
///
/// Bundles board background, grid line color, and stone colors for
/// both players into one swappable object.
class BoardTheme {
  const BoardTheme({
    required this.id,
    required this.name,
    required this.boardColors,
    required this.lineColor,
    required this.stone1Base,
    required this.stone1Highlight,
    required this.stone1Edge,
    required this.stone2Base,
    required this.stone2Highlight,
    required this.stone2Edge,
  });

  final String id;

  /// Human-readable display name (not localized — kept intentionally short).
  final String name;

  /// Two gradient stops for the board (top-left → bottom-right).
  final List<Color> boardColors;

  /// Grid-line stroke color (alpha premixed).
  final Color lineColor;

  final Color stone1Base;
  final Color stone1Highlight;
  final Color stone1Edge;
  final Color stone2Base;
  final Color stone2Highlight;
  final Color stone2Edge;

  // ── Presets ───────────────────────────────────────────────────────────────

  /// Current default — warm earth / clay tones.
  static const classic = BoardTheme(
    id: "classic",
    name: "Classique",
    boardColors: [Color(0xFF3A2E22), Color(0xFF16100B)],
    lineColor: Color(0x8CD4952B),
    stone1Base: Color(0xFFEAD9AF),
    stone1Highlight: Colors.white,
    stone1Edge: Color(0xFFD4952B),
    stone2Base: Color(0xFF271B13),
    stone2Highlight: Color(0xFF5A4A3A),
    stone2Edge: Color(0xFFC04832),
  );

  /// Deep indigo night sky.
  static const night = BoardTheme(
    id: "night",
    name: "Nuit",
    boardColors: [Color(0xFF1A1F35), Color(0xFF0D1020)],
    lineColor: Color(0x8C6E8DD4),
    stone1Base: Color(0xFFB8C8F0),
    stone1Highlight: Colors.white,
    stone1Edge: Color(0xFF6E8DD4),
    stone2Base: Color(0xFF1A2440),
    stone2Highlight: Color(0xFF2A3B60),
    stone2Edge: Color(0xFF3D5FA0),
  );

  /// Dense forest undergrowth.
  static const forest = BoardTheme(
    id: "forest",
    name: "Forêt",
    boardColors: [Color(0xFF1A2E1A), Color(0xFF0D1A0D)],
    lineColor: Color(0x8C5D9A5D),
    stone1Base: Color(0xFFC5E8C5),
    stone1Highlight: Colors.white,
    stone1Edge: Color(0xFF5D9A5D),
    stone2Base: Color(0xFF142614),
    stone2Highlight: Color(0xFF234023),
    stone2Edge: Color(0xFF3D7A3D),
  );

  /// Warm sandstone desert.
  static const sandstone = BoardTheme(
    id: "sandstone",
    name: "Grès",
    boardColors: [Color(0xFF4A3C2A), Color(0xFF2E2416)],
    lineColor: Color(0x8CB8916A),
    stone1Base: Color(0xFFF5E8C8),
    stone1Highlight: Colors.white,
    stone1Edge: Color(0xFFB8916A),
    stone2Base: Color(0xFF3A2A16),
    stone2Highlight: Color(0xFF5A4A2A),
    stone2Edge: Color(0xFF8A6A40),
  );

  static const all = [classic, night, forest, sandstone];

  static BoardTheme fromId(String id) =>
      all.firstWhere((t) => t.id == id, orElse: () => classic);
}

// ─── Provider ───────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
class BoardThemeNotifier extends _$BoardThemeNotifier {
  static const _key = "board_theme_id";

  @override
  BoardTheme build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final id = prefs.getString(_key) ?? BoardTheme.classic.id;
    return BoardTheme.fromId(id);
  }

  Future<void> setTheme(BoardTheme theme) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, theme.id);
    state = theme;
  }
}
