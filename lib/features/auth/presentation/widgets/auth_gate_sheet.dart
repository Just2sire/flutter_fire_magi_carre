import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_assets.dart";
import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/extensions/failure_extensions.dart";
import "../../../../core/extensions/navigation_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/material/app_bottom_sheet_handle_bar.dart";
import "../../domain/entities/auth_state.dart";
import "../providers/auth_providers.dart";
import "oauth_buttons_row.dart";

/// Bottom sheet d'invite à la connexion pour les utilisateurs en mode invité.
///
/// Propose les options OAuth (Google / GitHub), un raccourci vers la connexion
/// par e-mail, l'inscription, et un bouton pour rester invité.
/// Se ferme avec `true` dès qu'une authentification réussit.
class AuthGateSheet extends ConsumerStatefulWidget {
  const AuthGateSheet({super.key});

  @override
  ConsumerState<AuthGateSheet> createState() => _AuthGateSheetState();
}

class _AuthGateSheetState extends ConsumerState<AuthGateSheet> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isOAuthLoading = switch (authState) {
      AuthOAuthPending() || AuthLoading() => true,
      _ => false,
    };

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthAuthenticated && mounted) {
        Navigator.of(context).pop(true);
      }
    });

    final l10n = context.l10n;
    final cc = context.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cc.surface,
        borderRadius: AppSpacing.roundedTopXl,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Stack(
        children: [
          AbsorbPointer(
            absorbing: isOAuthLoading,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppBottomSheetHandleBar(),
                AppSpacing.gapVXxl,
                Padding(
                  padding: AppSpacing.screenPaddingH,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.authGateTitle,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.gapVSm,
                      Text(
                        l10n.authGateSubtitle,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: cc.onSurface.withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.gapVXxl,
                      OauthButtonsRow(
                        oauthProviders: _buildProviders(),
                        showLabel: true,
                        showAsRow: false,
                      ),
                      AppSpacing.gapVMd,
                      AppElevatedButton(
                        onPressed: isOAuthLoading ? null : _loginWithEmail,
                        text: l10n.authGateLoginWithEmail,
                      ),
                      AppSpacing.gapVSm,
                      OutlinedButton(
                        onPressed: isOAuthLoading ? null : _createAccount,
                        child: Text(l10n.authGateCreateAccount),
                      ),
                      AppSpacing.gapVMd,
                      TextButton(
                        onPressed: isOAuthLoading
                            ? null
                            : () => Navigator.of(context).pop(false),
                        child: Text(
                          l10n.authGateContinueAsGuest,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: cc.onSurface.withValues(alpha: 0.45),
                          ),
                        ),
                      ),
                      AppSpacing.gapVLg,
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isOAuthLoading)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: AppSpacing.roundedTopXl,
                child: ColoredBox(
                  color: cc.surface.withValues(alpha: 0.75),
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<OauthProviderInfo> _buildProviders() {
    return [
      (
        provider: "Google",
        image: AppAssets.googleLogo,
        label: "Google",
        onPressed: _signInWithGoogle,
      ),
      (
        provider: "GitHub",
        image: context.isDarkMode
            ? AppAssets.githubDarkLogo
            : AppAssets.githubLightLogo,
        label: "GitHub",
        onPressed: _signInWithGithub,
      ),
    ];
  }

  Future<void> _signInWithGoogle() async {
    await ref.read(authProvider.notifier).signInWithGoogle();
    if (!mounted) return;
    final authState = ref.read(authProvider);
    if (authState case AuthFailureState(:final failure)) {
      context.showSnackBar(context.localizeFailure(failure));
    }
  }

  Future<void> _signInWithGithub() async {
    await ref.read(authProvider.notifier).signInWithGithub();
    if (!mounted) return;
    final authState = ref.read(authProvider);
    if (authState case AuthFailureState(:final failure)) {
      context.showSnackBar(context.localizeFailure(failure));
    }
  }

  void _loginWithEmail() {
    Navigator.of(context).pop(false);
    context.pushAuthLogin<void>();
  }

  void _createAccount() {
    Navigator.of(context).pop(false);
    context.pushAuthSignup<void>();
  }
}
