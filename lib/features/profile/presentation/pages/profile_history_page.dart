import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/index.dart" show BuildContextExtensions;
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar, AppDivider;
import "../../../../shared/presentation/widgets/others/index.dart"
    show OfflineBanner;
import "../../../auth/domain/entities/auth_state.dart";
import "../../../auth/presentation/providers/auth_providers.dart";
import "../../../game/domain/entities/game_history_entry.dart";
import "../../../game/presentation/providers/game_history_providers.dart";

/// Historique de parties du joueur connecté.
class ProfileHistoryPage extends ConsumerWidget {
  const ProfileHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final authState = ref.watch(authProvider);

    if (authState is! AuthAuthenticated) {
      return AppScaffold(
        body: Column(
          children: [
            AppTopbar(title: l10n.profileActivityTitle),
            const Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      );
    }

    final playerId = authState.profile.id;
    final historyAsync = ref.watch(playerHistoryProvider(playerId));

    return AppScaffold(
      body: Column(
        children: [
          AppTopbar(title: l10n.profileActivityTitle),
          const OfflineBanner(),
          Expanded(
            child: historyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => _ErrorView(
                onRetry: () => ref.invalidate(playerHistoryProvider(playerId)),
              ),
              data: (entries) => entries.isEmpty
                  ? _EmptyView(message: l10n.profileHistoryEmpty)
                  : ListView.separated(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.md,
                        bottom: AppSpacing.bottomScrollablePadding,
                      ),
                      itemCount: entries.length,
                      separatorBuilder: (_, _) => const AppDivider(
                        height: 1,
                        indent: 72,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, i) =>
                          _HistoryEntryRow(entry: entries[i]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Private widgets ─────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingH,
        child: Text(
          message,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.alertCircle, size: 40, color: cs.error),
          AppSpacing.gapVMd,
          Text(
            context.l10n.commonError,
            style: tt.bodyMedium,
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapVMd,
          TextButton(onPressed: onRetry, child: Text(context.l10n.commonRetry)),
        ],
      ),
    );
  }
}

class _HistoryEntryRow extends StatelessWidget {
  const _HistoryEntryRow({required this.entry});

  final GameHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final locale = Localizations.localeOf(context).languageCode;

    final opponentLabel = switch (entry.opponentType) {
      "ai" => switch (entry.aiDifficulty) {
        "easy" => l10n.profileHistoryOpponentAiEasy,
        "medium" => l10n.profileHistoryOpponentAiMedium,
        "hard" => l10n.profileHistoryOpponentAiHard,
        _ => "IA",
      },
      "online" => l10n.profileHistoryOpponentOnline,
      _ => l10n.profileHistoryOpponentHuman,
    };

    final deltaText = entry.ratingDelta > 0
        ? "+${entry.ratingDelta}"
        : entry.ratingDelta < 0
        ? "${entry.ratingDelta}"
        : "±0";

    final deltaColor = entry.ratingDelta > 0
        ? AppColors.primary
        : entry.ratingDelta < 0
        ? cs.error
        : cs.onSurfaceVariant;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: _ResultBadge(result: entry.result),
      title: Text(
        opponentLabel,
        style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        "${entry.boardSize}×${entry.boardSize}"
        " · ${entry.moveCount} coups",
        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            deltaText,
            style: tt.labelLarge?.copyWith(
              color: deltaColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            DateFormat("d MMM y", locale).format(entry.playedAt),
            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }


}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.result});

  final String result;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    final (color, icon) = switch (result) {
      "win" => (AppColors.primary, AppIcons.trophy),
      "loss" => (cs.error, AppIcons.x),
      _ => (cs.onSurfaceVariant, AppIcons.equal),
    };

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: AppSpacing.iconSm, color: color),
    );
  }
}
