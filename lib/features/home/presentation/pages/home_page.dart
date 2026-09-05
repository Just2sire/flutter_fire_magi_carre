import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/extensions/navigation_extensions.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/app_avatar.dart";
import "../../../../shared/presentation/widgets/others/app_section_label.dart";
import "../../../auth/domain/entities/auth_state.dart";
import "../../../auth/domain/entities/user_profile.dart";
import "../../../auth/presentation/providers/auth_providers.dart";
import "../../../leaderboard/domain/entities/leaderboard_entry.dart";
import "../../../leaderboard/presentation/providers/leaderboard_providers.dart";

/// Écran d'accueil — point d'entrée principal de l'application après
/// l'authentification.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final profile = switch (authState) {
      AuthAuthenticated(:final profile) => profile,
      _ => null,
    };

    return AppScaffold(
      scrollable: true,
      body: Column(
        spacing: AppSpacing.md,
        children: [
          _HeroHeader(profile: profile),
          _StatsStrip(profile: profile),
          const _PlayNowCard(),
          const _QuickModesSection(),
          const _LeaderboardPreview(),
        ],
      ),
    );

    /*
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HeroHeader(profile: profile)),
          SliverPadding(
            padding: AppSpacing.screenPaddingH.copyWith(
              top: AppSpacing.xl,
              bottom: AppSpacing.xxxl,
            ),
            sliver: SliverList.list(
              children: [
                _StatsStrip(profile: profile),
                AppSpacing.gapVXl,
                const _PlayNowCard(),
                AppSpacing.gapVXl,
                const _QuickModesSection(),
                AppSpacing.gapVXl,
                const _LeaderboardPreview(),
              ],
            ),
          ),
        ],
      ),
    );
    */
  }
}

// ─── Hero header ─────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final _ = MediaQuery.paddingOf(context).top;
    final username = profile?.username ?? l10n.homeGuestUsername;

    return Container(
      padding: AppSpacing.insetMd,
      decoration: const BoxDecoration(
        borderRadius: AppSpacing.roundedLg,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1409), Color(0xFF2D1E10), Color(0xFF3A2A14)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.homeGreeting(username),
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                AppSpacing.gapVSm,
                Text(
                  l10n.homeGreetingSubtitle,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.paleMint70,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapHLg,
          _AvatarBadge(avatarUrl: profile?.avatarUrl),
        ],
      ),
    );
  }
}

class _AvatarBadge extends StatefulWidget {
  const _AvatarBadge({this.avatarUrl});

  final String? avatarUrl;

  @override
  State<_AvatarBadge> createState() => _AvatarBadgeState();
}

class _AvatarBadgeState extends State<_AvatarBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: const Offset(0, 0.05),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: AppSpacing.roundedLg,
          border: Border.all(
            color: AppColors.primary.withAlpha(50),
            width: AppSpacing.borderWidthMedium,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: AppAvatar(
          avatarUrl: widget.avatarUrl,
          radius: AppSpacing.avatarXl / 2,
        ),
      ),
    );
  }
}

// ─── Stats strip ─────────────────────────────────────────────────────────────

class _StatsStrip extends ConsumerWidget {
  const _StatsStrip({required this.profile});

  final UserProfile? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final rankAsync = ref.watch(myRankProvider);

    final rankLabel = rankAsync.when(
      data: (entry) => "#${entry.rank}",
      loading: () => "…",
      error: (_, _) => l10n.homeStatPlaceholder,
    );

    return Row(
      spacing: AppSpacing.sm,
      children: [
        Expanded(
          child: _StatCard(
            icon: AppIcons.zap,
            iconColor: AppColors.primary,
            // iconColor: const Color(0xFFF59E0B),
            value: l10n.homeStatPlaceholder,
            label: l10n.homeStatStreak,
          ),
        ),
        Expanded(
          child: _StatCard(
            icon: AppIcons.trophy,
            iconColor: const Color(0xFF60A5FA),
            value: profile != null
                ? profile!.rating.toString()
                : l10n.homeStatPlaceholder,
            label: l10n.homeStatRating,
          ),
        ),
        Expanded(
          child: _StatCard(
            icon: AppIcons.crown,
            iconColor: AppColors.primary,
            value: rankLabel,
            label: l10n.homeStatRank,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: AppSpacing.roundedXl,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: AppSpacing.iconLg),
            AppSpacing.gapVXs,
            Text(
              value,
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Play now card ───────────────────────────────────────────────────────────

class _PlayNowCard extends StatelessWidget {
  const _PlayNowCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: () => context.pushGameLobby<void>(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.surfaceRaisedDark, AppColors.surfaceCardDark],
          ),
          borderRadius: AppSpacing.roundedXxl,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: Padding(
          padding: AppSpacing.insetXl,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  spacing: AppSpacing.xs,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: AppSpacing.large,
                      height: AppSpacing.xs,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: AppSpacing.roundedFull,
                      ),
                    ),
                    Text(
                      l10n.homePlayNowTitle,
                      style: tt.headlineSmall?.copyWith(
                        color: AppColors.neutral50,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      l10n.homePlayNowSubtitle,
                      style: tt.bodyMedium?.copyWith(
                        color: AppColors.paleMint70,
                      ),
                    ),
                    AppSpacing.gapVXs,
                    FilledButton.icon(
                      onPressed: () => context.pushGameLobby<void>(),
                      icon: const Icon(AppIcons.play, size: 18),
                      label: Text(l10n.homePlayNowCta),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const _BoardDecoration(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Décoration visuelle abstraite représentant un plateau de jeu 3×3.
class _BoardDecoration extends StatelessWidget {
  const _BoardDecoration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: List.generate(9, (i) {
          final isHighlighted = i == 4 || i == 0 || i == 8;
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isHighlighted
                  ? AppColors.primary.withValues(alpha: 0.7)
                  : AppColors.primary.withValues(alpha: 0.15),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Quick modes section ─────────────────────────────────────────────────────

class _QuickModesSection extends StatelessWidget {
  const _QuickModesSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      spacing: AppSpacing.sm,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionLabel(text: l10n.homeQuickModesTitle),
        Row(
          spacing: AppSpacing.sm,
          children: [
            _ModeChip(
              icon: AppIcons.bot,
              label: l10n.homeModeBot,
              onTap: () => context.pushGameLobby<void>(),
            ),
            _ModeChip(
              icon: AppIcons.users,
              label: l10n.homeMode2p,
              onTap: () => context.pushGameLobby<void>(),
            ),
            _ModeChip(
              icon: AppIcons.globe,
              label: l10n.homeModeOnline,
              badge: l10n.homeModeOnlineSoon,
              onTap: null,
            ),
            _ModeChip(
              icon: AppIcons.bookOpen,
              label: l10n.homeModeRules,
              onTap: () => context.pushLearn<void>(),
            ),
          ],
        ),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final enabled = onTap != null;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedOpacity(
          duration: AppSpacing.durationBase,
          opacity: enabled ? 1.0 : 0.45,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: AppSpacing.roundedXl,
              border: Border.all(
                color: enabled
                    ? cs.outlineVariant
                    : cs.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              spacing: AppSpacing.xs,
              mainAxisAlignment: .center,
              // mainAxisSize: .min,
              children: [
                Icon(
                  icon,
                  size: AppSpacing.iconLg,
                  color: enabled ? AppColors.primary : cs.onSurfaceVariant,
                ),
                Text(
                  label,
                  style: tt.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  badge ?? "",
                  style: tt.labelSmall?.copyWith(
                    color: AppColors.semanticError,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Leaderboard preview ─────────────────────────────────────────────────────

class _LeaderboardPreview extends ConsumerWidget {
  const _LeaderboardPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final topAsync = ref.watch(topPlayersProvider(limit: 3));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppSectionLabel(text: l10n.homeLeaderboardTitle),
            TextButton(
              onPressed: () => context.goLeaderboard(),
              child: Text(l10n.homeLeaderboardSeeAll),
            ),
          ],
        ),
        AppSpacing.gapVSm,
        topAsync.when(
          data: (entries) => Column(
            children: entries.map((e) => _LeaderboardRow(entry: e)).toList(),
          ),
          loading: () => const _LeaderboardSkeleton(),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final isTop3 = entry.rank <= 3;

    final medalColor = switch (entry.rank) {
      1 => const Color(0xFFFFD700),
      2 => const Color(0xFFC0C0C0),
      3 => const Color(0xFFCD7F32),
      _ => cs.onSurfaceVariant,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: AppSpacing.roundedXl,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            spacing: AppSpacing.md,
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  "#${entry.rank}",
                  style: tt.labelMedium?.copyWith(
                    color: isTop3 ? medalColor : cs.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              AppAvatar(avatarUrl: entry.avatarUrl, radius: AppSpacing.xl),
              Expanded(
                child: Text(
                  entry.username,
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                entry.rating.toString(),
                style: tt.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderboardSkeleton extends StatelessWidget {
  const _LeaderboardSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Column(
      children: List.generate(
        3,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: AppSpacing.roundedXl,
            ),
            child: const SizedBox(height: 52),
          ),
        ),
      ),
    );
  }
}
