import "package:flutter/material.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/index.dart" show BuildContextExtensions;
import "../../../../core/theme/app_spacing.dart";

// ─── Timer preset & category data ─────────────────────────────────────────

/// Un preset de cadence : temps de base + incrément par coup (en secondes).
class _TimerPreset {
  const _TimerPreset(this.baseSeconds, this.incrementSeconds);

  final int baseSeconds;
  final int incrementSeconds;

  /// Affichage : "1 min", "1 + 1", "3 + 2", "15 + 10"…
  String get label {
    final m = baseSeconds ~/ 60;
    if (incrementSeconds == 0) return "$m min";
    return "$m + $incrementSeconds";
  }
}

class _TimerCategory {
  const _TimerCategory({
    required this.label,
    required this.icon,
    required this.presets,
  });

  final String label;
  final IconData icon;
  final List<_TimerPreset> presets;
}

// ─── Timer picker ──────────────────────────────────────────────────────────

/// Sélecteur de cadence style chess — catégories Bullet / Blitz / Rapide
/// avec boutons "X min" ou "X + Y" et option "Aucun". Partagé entre le mode
/// 2 joueurs local et les parties en ligne.
class TimerPicker extends StatelessWidget {
  const TimerPicker({
    required this.selectedBase,
    required this.selectedIncrement,
    required this.onChanged,
    super.key,
  });

  final int selectedBase;
  final int selectedIncrement;
  final void Function(int base, int increment) onChanged;

  static const _categories = [
    _TimerCategory(
      label: "Bullet",
      icon: AppIcons.bullet,
      presets: [_TimerPreset(60, 0), _TimerPreset(60, 1), _TimerPreset(120, 1)],
    ),
    _TimerCategory(
      label: "Blitz",
      icon: AppIcons.zap,
      presets: [
        _TimerPreset(180, 0),
        _TimerPreset(180, 2),
        _TimerPreset(300, 0),
      ],
    ),
    _TimerCategory(
      label: "Rapide",
      icon: AppIcons.timer,
      presets: [
        _TimerPreset(600, 0),
        _TimerPreset(900, 10),
        _TimerPreset(1800, 0),
      ],
    ),
  ];

  bool _isSelected(_TimerPreset p) =>
      p.baseSeconds == selectedBase && p.incrementSeconds == selectedIncrement;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Pas de minuterie ─────────────────────────────────────────────
        _TimerPresetButton(
          label: l10n.gameLobbyLocal2pTimerNone,
          isSelected: selectedBase == 0,
          onTap: () => onChanged(0, 0),
        ),
        AppSpacing.gapVLg,
        // ── Catégories ───────────────────────────────────────────────────
        for (final cat in _categories) ...[
          Row(
            spacing: AppSpacing.xs,
            children: [
              Icon(cat.icon, size: 16, color: cs.onSurface),
              Text(
                cat.label,
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          AppSpacing.gapVSm,
          Row(
            spacing: AppSpacing.sm,
            children: [
              for (final preset in cat.presets)
                Expanded(
                  child: _TimerPresetButton(
                    label: preset.label,
                    isSelected: _isSelected(preset),
                    onTap: () =>
                        onChanged(preset.baseSeconds, preset.incrementSeconds),
                  ),
                ),
            ],
          ),
          AppSpacing.gapVLg,
        ],
      ],
    );
  }
}

/// Bouton de sélection d'une durée de minuterie.
class _TimerPresetButton extends StatelessWidget {
  const _TimerPresetButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSpacing.durationFast,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
        decoration: BoxDecoration(
          color: isSelected ? cs.primaryContainer : cs.surfaceContainer,
          borderRadius: AppSpacing.roundedMd,
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected
                ? AppSpacing.borderWidthMedium
                : AppSpacing.borderWidthBase,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: tt.labelLarge?.copyWith(
              color: isSelected ? cs.primary : cs.onSurface,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
