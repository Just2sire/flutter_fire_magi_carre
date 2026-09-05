import "package:carre_magic_logic/carre_magic_logic.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppElevatedButton, AppOutlinedButton, AppScaffold, AppTopbar;
import "../../../../shared/presentation/widgets/others/index.dart"
    show AppGroupedCard, AppSectionLabel, AppTileRow;
import "../../../auth/domain/entities/auth_state.dart";
import "../../../auth/presentation/providers/auth_providers.dart";
import "../../../game/presentation/widgets/index.dart" show TimerPicker;
import "../../domain/entities/online_match.dart";
import "../providers/matchmaking_providers.dart";
import "../providers/online_match_providers.dart";

/// Hub des parties en ligne — partie rapide (file d'attente), création
/// d'invitation, jointure par code, et reprise des parties en cours.
class LobbyPage extends ConsumerStatefulWidget {
  const LobbyPage({super.key});

  @override
  ConsumerState<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends ConsumerState<LobbyPage> {
  int _timerBase = 180;
  int _timerIncrement = 2;
  final _codeController = TextEditingController();
  bool _joiningByCode = false;
  String? _joinError;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    ref.listen(matchmakingQueueProvider, (previous, next) {
      if (next.status == MatchmakingStatus.matched && next.matchId != null) {
        context.goGameOnline(next.matchId!);
      }
    });

    final authState = ref.watch(authProvider);
    if (authState is! AuthAuthenticated) {
      return AppScaffold(
        body: Column(
          children: [
            AppTopbar(title: l10n.onlineLobbyTitle),
            const Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      );
    }

    final matchmaking = ref.watch(matchmakingQueueProvider);

    return AppScaffold(
      body: Column(
        children: [
          AppTopbar(title: l10n.onlineLobbyTitle),
          Expanded(
            child: matchmaking.status == MatchmakingStatus.searching
                ? _SearchingView(
                    onCancel: () => ref
                        .read(matchmakingQueueProvider.notifier)
                        .cancel(),
                  )
                : ListView(
                    // padding: const EdgeInsets.only(
                    //   top: AppSpacing.md,
                    //   bottom: AppSpacing.bottomScrollablePadding,
                    // ),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ResumeMatchesSection(myId: authState.profile.id),
                          AppSpacing.gapVXl,
                          AppSectionLabel(
                            text: l10n.onlineLobbyQuickMatchTitle,
                          ),
                          AppSpacing.gapVSm,
                          TimerPicker(
                            selectedBase: _timerBase,
                            selectedIncrement: _timerIncrement,
                            onChanged: (base, inc) => setState(() {
                              _timerBase = base;
                              _timerIncrement = inc;
                            }),
                          ),
                          AppSpacing.gapVMd,
                          if (matchmaking.status ==
                              MatchmakingStatus.error) ...[
                            Text(
                              matchmaking.errorMessage ?? l10n.commonError,
                              style: TextStyle(
                                color: context.colorScheme.error,
                              ),
                            ),
                            AppSpacing.gapVSm,
                          ],
                          AppElevatedButton(
                            text: l10n.onlineLobbyQuickMatchCta,
                            onPressed: () => ref
                                .read(
                                  matchmakingQueueProvider.notifier,
                                )
                                .join(
                                  timerBaseSeconds: _timerBase,
                                  timerIncrementSeconds: _timerIncrement,
                                ),
                          ),
                          AppSpacing.gapVXxl,
                          AppSectionLabel(text: l10n.onlineLobbyInviteTitle),
                          AppSpacing.gapVSm,
                          AppOutlinedButton(
                            text: l10n.onlineLobbyCreateInviteCta,
                            onPressed: () => context.pushLobbyCreate<void>(),
                          ),
                          AppSpacing.gapVMd,
                          _JoinByCodeField(
                            controller: _codeController,
                            isLoading: _joiningByCode,
                            errorText: _joinError,
                            onSubmit: _joinByCode,
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _joinByCode() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() {
      _joiningByCode = true;
      _joinError = null;
    });

    final result = await ref
        .read(joinInviteMatchUseCaseProvider)
        .call(code);
    if (!mounted) return;

    result.fold(
      (failure) => setState(() {
        _joiningByCode = false;
        _joinError = context.l10n.onlineLobbyInvalidCode;
      }),
      (matchId) {
        setState(() => _joiningByCode = false);
        context.goGameOnline(matchId);
      },
    );
  }
}

// ─── Recherche d'adversaire ─────────────────────────────────────────────

class _SearchingView extends StatelessWidget {
  const _SearchingView({required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tt = context.textTheme;

    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingH,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            AppSpacing.gapVLg,
            Text(
              l10n.onlineLobbySearching,
              style: tt.titleMedium,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVXl,
            AppOutlinedButton(
              text: l10n.onlineLobbyCancelSearch,
              onPressed: onCancel,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Parties à reprendre ─────────────────────────────────────────────────

class _ResumeMatchesSection extends ConsumerWidget {
  const _ResumeMatchesSection({required this.myId});

  final String myId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final matchesAsync = ref.watch(myActiveMatchesProvider);

    return matchesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (matches) {
        if (matches.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSectionLabel(text: l10n.onlineLobbyResumeTitle),
            AppSpacing.gapVSm,
            AppGroupedCard(
              children: [
                for (var i = 0; i < matches.length; i++)
                  _ResumeMatchTile(
                    match: matches[i],
                    myId: myId,
                    isLast: i == matches.length - 1,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ResumeMatchTile extends StatelessWidget {
  const _ResumeMatchTile({
    required this.match,
    required this.myId,
    required this.isLast,
  });

  final OnlineMatch match;
  final String myId;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final myColor = match.colorFor(myId);
    final subtitle = myColor == PlayerColor.white
        ? l10n.onlineLobbyResumeSubtitleWhite
        : l10n.onlineLobbyResumeSubtitleBlack;

    return AppTileRow(
      icon: AppIcons.globe,
      title: l10n.onlineLobbyResumeMatch,
      subtitle: subtitle,
      isLast: isLast,
      onTap: () => context.goGameOnline(match.id),
    );
  }
}

// ─── Rejoindre par code ──────────────────────────────────────────────────

class _JoinByCodeField extends StatelessWidget {
  const _JoinByCodeField({
    required this.controller,
    required this.isLoading,
    required this.onSubmit,
    this.errorText,
  });

  final TextEditingController controller;
  final bool isLoading;
  final String? errorText;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: l10n.onlineLobbyJoinCodeLabel,
              errorText: errorText,
            ),
            onSubmitted: (_) => onSubmit(),
          ),
        ),
        AppSpacing.gapHSm,
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: AppElevatedButton(
            text: l10n.onlineLobbyJoinCta,
            isLoading: isLoading,
            buttonSize: const Size(120, AppSpacing.buttonHeightLg),
            onPressed: isLoading ? null : onSubmit,
          ),
        ),
      ],
    );
  }
}
