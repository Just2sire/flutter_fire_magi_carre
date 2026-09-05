import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppElevatedButton, AppScaffold, AppTopbar;
import "../../../../shared/presentation/widgets/others/index.dart"
    show AppGroupedCard, AppSectionLabel;
import "../../../game/presentation/widgets/index.dart" show TimerPicker;
import "../../domain/entities/online_match.dart";
import "../providers/online_match_providers.dart";

/// Configure puis crée une partie en attente d'invitation — cadence, toggle
/// classé/amical, génération du code à partager, écran d'attente jusqu'à
/// ce qu'un adversaire rejoigne.
class CreateInvitePage extends ConsumerStatefulWidget {
  const CreateInvitePage({super.key});

  @override
  ConsumerState<CreateInvitePage> createState() => _CreateInvitePageState();
}

class _CreateInvitePageState extends ConsumerState<CreateInvitePage> {
  int _timerBase = 180;
  int _timerIncrement = 2;
  bool _rated = true;
  bool _creating = false;
  String? _error;
  String? _code;
  StreamSubscription<OnlineMatch>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _generate() async {
    setState(() {
      _creating = true;
      _error = null;
    });

    final createResult = await ref
        .read(createInviteMatchUseCaseProvider)
        .call(
          timerBaseSeconds: _timerBase,
          timerIncrementSeconds: _timerIncrement,
          rated: _rated,
        );
    if (!mounted) return;

    await createResult.fold(
      (failure) async {
        setState(() {
          _creating = false;
          _error = failure.message;
        });
      },
      (code) async {
        final matchResult = await ref
            .read(getMatchByInviteCodeUseCaseProvider)
            .call(code);
        if (!mounted) return;
        matchResult.fold(
          (failure) => setState(() {
            _creating = false;
            _error = failure.message;
          }),
          (match) {
            setState(() {
              _creating = false;
              _code = code;
            });
            _listenForOpponent(match.id);
          },
        );
      },
    );
  }

  void _listenForOpponent(String matchId) {
    _subscription = ref
        .read(watchMatchUseCaseProvider)
        .call(matchId)
        .listen((match) {
          if (mounted && match.status == MatchStatus.active) {
            context.goGameOnline(matchId);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      body: Column(
        children: [
          AppTopbar(title: l10n.onlineInviteTitle),
          Expanded(
            child: Padding(
              padding: AppSpacing.screenPaddingH,
              child: _code != null
                  ? _WaitingForOpponentView(code: _code!)
                  : _ConfigForm(
                      timerBase: _timerBase,
                      timerIncrement: _timerIncrement,
                      rated: _rated,
                      isLoading: _creating,
                      error: _error,
                      onTimerChanged: (base, inc) => setState(() {
                        _timerBase = base;
                        _timerIncrement = inc;
                      }),
                      onRatedChanged: (v) => setState(() => _rated = v),
                      onGenerate: _generate,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfigForm extends StatelessWidget {
  const _ConfigForm({
    required this.timerBase,
    required this.timerIncrement,
    required this.rated,
    required this.isLoading,
    required this.onTimerChanged,
    required this.onRatedChanged,
    required this.onGenerate,
    this.error,
  });

  final int timerBase;
  final int timerIncrement;
  final bool rated;
  final bool isLoading;
  final String? error;
  final void Function(int base, int increment) onTimerChanged;
  final ValueChanged<bool> onRatedChanged;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSpacing.gapVMd,
          AppSectionLabel(text: l10n.onlineInviteTimerTitle),
          AppSpacing.gapVSm,
          TimerPicker(
            selectedBase: timerBase,
            selectedIncrement: timerIncrement,
            onChanged: onTimerChanged,
          ),
          AppSpacing.gapVLg,
          AppGroupedCard(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.onlineInviteRatedToggle,
                            style: context.textTheme.bodyMedium,
                          ),
                          Text(
                            l10n.onlineInviteRatedSubtitle,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(value: rated, onChanged: onRatedChanged),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapVLg,
          if (error != null) ...[
            Text(error!, style: TextStyle(color: context.colorScheme.error)),
            AppSpacing.gapVSm,
          ],
          AppElevatedButton(
            text: l10n.onlineInviteGenerateCta,
            isLoading: isLoading,
            onPressed: isLoading ? null : onGenerate,
          ),
        ],
      ),
    );
  }
}

class _WaitingForOpponentView extends StatelessWidget {
  const _WaitingForOpponentView({required this.code});

  final String code;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.onlineInviteCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tt = context.textTheme;
    final cs = context.colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.onlineInviteShareTitle, style: tt.titleMedium),
          AppSpacing.gapVLg,
          Container(
            padding: AppSpacing.insetLg,
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: AppSpacing.roundedXl,
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Text(
              code,
              style: tt.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
              ),
            ),
          ),
          AppSpacing.gapVLg,
          AppElevatedButton(
            text: l10n.onlineInviteCopyCta,
            onPressed: () => _copy(context),
          ),
          AppSpacing.gapVXl,
          const CircularProgressIndicator(),
          AppSpacing.gapVMd,
          Text(
            l10n.onlineInviteWaiting,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
