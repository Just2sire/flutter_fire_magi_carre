import "package:flutter/material.dart";

import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/others/app_avatar.dart";
import "../../domain/entities/leaderboard_entry.dart";

/// Ligne d'un joueur dans la liste du classement (rang 4 et au-delà).
class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow({
    required this.entry,
    super.key,
    this.isCurrentUser = false,
  });

  final LeaderboardEntry entry;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isCurrentUser ? cs.primaryContainer : Colors.transparent,
        borderRadius: AppSpacing.roundedLg,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              "${entry.rank}",
              style: tt.titleSmall?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
          AppSpacing.gapHMd,
          AppAvatar(avatarUrl: entry.avatarUrl, radius: AppSpacing.xl),
          AppSpacing.gapHMd,
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    entry.username,
                    style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    overflow: .ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (isCurrentUser) ...[
                  AppSpacing.gapHSm,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: AppSpacing.roundedSm,
                    ),
                    child: Text(
                      l10n.leaderboardYou,
                      style: tt.labelSmall?.copyWith(color: cs.onPrimary),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            l10n.leaderboardRatingLabel(entry.rating),
            style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
