import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppElevatedButton, AppScaffold, AppTopbar;
import "../providers/online_match_providers.dart";

/// Rejoint une partie par son code d'invitation — pré-rempli quand l'écran
/// est ouvert via un deep-link `/lobby/join/:inviteCode`.
class JoinInvitePage extends ConsumerStatefulWidget {
  const JoinInvitePage({super.key});

  @override
  ConsumerState<JoinInvitePage> createState() => _JoinInvitePageState();
}

class _JoinInvitePageState extends ConsumerState<JoinInvitePage> {
  late final TextEditingController _controller;
  bool _joining = false;
  String? _error;
  bool _initialized = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final code =
          GoRouterState.of(context).pathParameters["inviteCode"] ?? "";
      _controller = TextEditingController(text: code.toUpperCase());
    }
  }

  Future<void> _join() async {
    final code = _controller.text.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() {
      _joining = true;
      _error = null;
    });

    final result = await ref.read(joinInviteMatchUseCaseProvider).call(code);
    if (!mounted) return;

    result.fold(
      (failure) => setState(() {
        _joining = false;
        _error = context.l10n.onlineLobbyInvalidCode;
      }),
      (matchId) {
        setState(() => _joining = false);
        context.goGameOnline(matchId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      body: Column(
        children: [
          AppTopbar(title: l10n.onlineJoinTitle),
          Expanded(
            child: Padding(
              padding: AppSpacing.screenPaddingH,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.characters,
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.onlineLobbyJoinCodeLabel,
                      hintText: l10n.onlineJoinCodeHint,
                      errorText: _error,
                    ),
                    onSubmitted: (_) => _join(),
                  ),
                  AppSpacing.gapVLg,
                  AppElevatedButton(
                    text: l10n.onlineJoinCta,
                    isLoading: _joining,
                    onPressed: _joining ? null : _join,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
