import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/extensions/index.dart" show BuildContextExtensions;
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppElevatedButton;
import "../../../../shared/presentation/widgets/inputs/app_text_form_field.dart";
import "../../../../shared/presentation/widgets/others/app_avatar.dart";
import "../../../auth/domain/entities/auth_state.dart";
import "../../../auth/presentation/providers/auth_providers.dart";

/// Page de configuration initiale du profil — affichée une seule fois après
/// la première inscription. L'utilisateur peut renseigner une bio (optionnel)
/// avant de commencer à jouer. La page est gardée par le router tant que
/// `UserProfile.onboardingCompleted == false`.
class ProfileSetupPage extends ConsumerStatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage> {
  final _bioController = TextEditingController();
  var _loading = false;

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() => _loading = true);

    final notifier = ref.read(authProvider.notifier);
    final bio = _bioController.text.trim();

    if (bio.isNotEmpty) {
      final result = await notifier.updateBio(bio);
      if (!mounted) return;
      if (result.isLeft) {
        setState(() => _loading = false);
        context.showSnackBar(context.l10n.commonError);
        return;
      }
    }

    final result = await notifier.completeOnboarding();
    if (!mounted) return;

    if (result.isLeft) {
      setState(() => _loading = false);
      context.showSnackBar(context.l10n.commonError);
    }
    // En cas de succès, le router détecte onboardingCompleted == true
    // via refreshListenable et redirige automatiquement vers home.
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    if (authState is! AuthAuthenticated) return const SizedBox.shrink();

    final profile = authState.profile;
    final l10n = context.l10n;
    final tt = context.textTheme;
    final cs = context.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.insetLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.gapVXxl,
              _HeroBanner(
                avatarUrl: profile.avatarUrl,
                title: l10n.profileSetupTitle(profile.username),
                subtitle: l10n.profileSetupSubtitle,
              ),
              AppSpacing.gapVXxxl,
              Text(
                l10n.profileEditBioLabel,
                style: tt.labelLarge?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapVSm,
              AppTextFormField(
                controller: _bioController,
                hintText: l10n.profileSetupBioHint,
                maxLines: 4,
                enabled: !_loading,
              ),
              AppSpacing.gapVXxxl,
              AppElevatedButton(
                text: l10n.profileSetupCta,
                onPressed: _loading ? null : _submit,
                isLoading: _loading,
              ),
              AppSpacing.gapVLg,
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Hero banner ─────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.avatarUrl,
    required this.title,
    required this.subtitle,
  });

  final String? avatarUrl;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;

    return Container(
      padding: AppSpacing.insetLg,
      decoration: const BoxDecoration(
        borderRadius: AppSpacing.roundedXl,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.neutral900, AppColors.primaryPressed],
        ),
      ),
      child: Column(
        children: [
          AppAvatar(avatarUrl: avatarUrl),
          AppSpacing.gapVMd,
          Text(
            title,
            style: tt.headlineSmall?.copyWith(
              color: AppColors.paleMint,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapVXs,
          Text(
            subtitle,
            style: tt.bodyMedium?.copyWith(color: AppColors.paleMint70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
