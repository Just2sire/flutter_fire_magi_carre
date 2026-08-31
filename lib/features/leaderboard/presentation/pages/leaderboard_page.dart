import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/index.dart" show BuildContextExtensions;
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar, AppElevatedButton, AppDivider;
import "../../../../shared/presentation/widgets/others/index.dart"
    show AppSectionLabel, SkeletonList, SkeletonTile;
import "../../../auth/domain/entities/auth_state.dart";
import "../../../auth/presentation/providers/auth_providers.dart";
import "../../domain/entities/leaderboard_entry.dart";
import "../providers/leaderboard_providers.dart";
import "../widgets/index.dart";

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final entriesAsync = ref.watch(topPlayersProvider());
    final authState = ref.watch(authProvider);
    final myId = authState is AuthAuthenticated ? authState.profile.id : null;

    return AppScaffold(
      scrollable: true,
      body: Column(
        // crossAxisAlignment: .stretch,
        children: [
          AppTopbar(
            title: l10n.leaderboardTitle,
            subtitle: l10n.leaderboardSubtitle,
            showLeading: false,
          ),
          AppSpacing.gapVXl,
          entriesAsync.when(
            loading: () => SkeletonList(
              itemCount: 8,
              separated: true,
              itemBuilder: (_, _) => const SkeletonTile(),
            ),
            error: (error, stackTrace) => _LeaderboardError(
              onRetry: () => ref.invalidate(topPlayersProvider),
            ),
            data: (entries) {
              if (entries.isEmpty) return const _LeaderboardEmpty();

              final topThree = entries.take(3).toList();
              final rest = entries.length > 3
                  ? entries.sublist(3)
                  : const <LeaderboardEntry>[];
              final isMeVisible =
                  myId != null && entries.any((e) => e.userId == myId);

              return Column(
                crossAxisAlignment: .stretch,
                children: [
                  LeaderboardPodium(topThree: topThree),
                  if (rest.isNotEmpty) ...[
                    AppSpacing.gapVXxl,
                    AppSectionLabel(text: l10n.leaderboardTop50),
                    AppSpacing.gapVSm,
                    for (final entry in rest)
                      LeaderboardRow(
                        entry: entry,
                        isCurrentUser: entry.userId == myId,
                      ),
                  ],
                  if (myId != null && !isMeVisible) ...[
                    AppSpacing.gapVXl,
                    const AppDivider(),
                    AppSpacing.gapVMd,
                    AppSectionLabel(text: l10n.leaderboardMyRank),
                    AppSpacing.gapVSm,
                    const _MyRankPinned(),
                  ],
                  AppSpacing.gapVLg,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Rang de l'utilisateur courant, affiché même quand il n'apparaît pas
/// dans la page de classement actuellement chargée.
class _MyRankPinned extends ConsumerWidget {
  const _MyRankPinned();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myRankAsync = ref.watch(myRankProvider);

    return myRankAsync.when(
      loading: () => const SkeletonTile(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (entry) => LeaderboardRow(entry: entry, isCurrentUser: true),
    );
  }
}

class _LeaderboardEmpty extends StatelessWidget {
  const _LeaderboardEmpty();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tt = context.textTheme;
    final cs = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
      child: Column(
        children: [
          Icon(AppIcons.navLeaderboard, size: 48, color: cs.onSurfaceVariant),
          AppSpacing.gapVMd,
          Text(l10n.leaderboardEmptyTitle, style: tt.titleMedium),
          AppSpacing.gapVSm,
          Text(
            l10n.leaderboardEmptySubtitle,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LeaderboardError extends StatelessWidget {
  const _LeaderboardError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tt = context.textTheme;
    final cs = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
      child: Column(
        children: [
          Icon(AppIcons.alertCircle, size: 48, color: cs.error),
          AppSpacing.gapVMd,
          Text(l10n.leaderboardErrorTitle, style: tt.titleMedium),
          AppSpacing.gapVSm,
          Text(
            l10n.leaderboardErrorMessage,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapVLg,
          AppElevatedButton(text: l10n.commonRetry, onPressed: onRetry),
        ],
      ),
    );
  }
}
