import "package:flutter/material.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/others/app_avatar.dart";
import "../../domain/entities/leaderboard_entry.dart";

/// Podium des 3 premiers joueurs — 2ème / 1er / 3ème, comme sur un vrai podium.
class LeaderboardPodium extends StatelessWidget {
  const LeaderboardPodium({required this.topThree, super.key});

  final List<LeaderboardEntry> topThree;

  LeaderboardEntry? _at(int index) =>
      index < topThree.length ? topThree[index] : null;

  @override
  Widget build(BuildContext context) {
    final first = _at(0);
    final second = _at(1);
    final third = _at(2);

    return Row(
      crossAxisAlignment: .end,
      mainAxisAlignment: .center,
      children: [
        if (second != null)
          Expanded(
            child: _PodiumSpot(entry: second, style: _PodiumStyle.silver),
          ),
        Expanded(
          child: first != null
              ? _PodiumSpot(entry: first, style: _PodiumStyle.gold)
              : const SizedBox.shrink(),
        ),
        if (third != null)
          Expanded(
            child: _PodiumSpot(entry: third, style: _PodiumStyle.bronze),
          ),
      ],
    );
  }
}

enum _PodiumStyle { gold, silver, bronze }

extension on _PodiumStyle {
  Color get ringColor => switch (this) {
    _PodiumStyle.gold => const Color(0xFFD4952B),
    _PodiumStyle.silver => const Color(0xFFB8C0CC),
    _PodiumStyle.bronze => const Color(0xFFB8763F),
  };

  double get avatarRadius => switch (this) {
    _PodiumStyle.gold => AppSpacing.mega + 8,
    _PodiumStyle.silver => AppSpacing.mega,
    _PodiumStyle.bronze => AppSpacing.mega,
  };

  double get pedestalHeight => switch (this) {
    _PodiumStyle.gold => 64,
    _PodiumStyle.silver => 44,
    _PodiumStyle.bronze => 32,
  };
}

class _PodiumSpot extends StatelessWidget {
  const _PodiumSpot({required this.entry, required this.style});

  final LeaderboardEntry entry;
  final _PodiumStyle style;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      mainAxisSize: .min,
      children: [
        if (style == _PodiumStyle.gold)
          const Icon(AppIcons.crown, color: Color(0xFFD4952B), size: 28),
        AppSpacing.gapVXs,
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: style.ringColor, width: 3),
          ),
          child: AppAvatar(
            avatarUrl: entry.avatarUrl,
            radius: style.avatarRadius,
          ),
        ),
        AppSpacing.gapVSm,
        Text(
          entry.username,
          style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
          overflow: .ellipsis,
          maxLines: 1,
        ),
        Text(
          "${entry.rating}",
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
        AppSpacing.gapVSm,
        Container(
          width: double.infinity,
          height: style.pedestalHeight,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          decoration: BoxDecoration(
            color: style.ringColor.withAlpha(46),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.md),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            "#${entry.rank}",
            style: tt.titleMedium?.copyWith(
              color: style.ringColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
