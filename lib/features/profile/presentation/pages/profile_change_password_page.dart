import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/failure_extensions.dart";
import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar, AppTextFormField, AppElevatedButton;
import "../../../auth/presentation/providers/auth_providers.dart";

/// Changement de mot de passe volontaire, en session — contrairement au
/// flow de récupération (reset password), ne déconnecte PAS l'utilisateur
/// après succès.
class ProfileChangePasswordPage extends ConsumerStatefulWidget {
  const ProfileChangePasswordPage({super.key});

  @override
  ConsumerState<ProfileChangePasswordPage> createState() =>
      _ProfileChangePasswordPageState();
}

class _ProfileChangePasswordPageState
    extends ConsumerState<ProfileChangePasswordPage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  late bool _obscureNew;
  late bool _obscureConfirm;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _obscureNew = true;
    _obscureConfirm = true;
    _formKey = GlobalKey<FormState>();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      scrollable: true,
      body: Column(
        children: [
          AppTopbar(title: l10n.authResetPasswordTitle),
          AppSpacing.gapVXxl,
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextFormField(
                  isRequired: true,
                  labelText: l10n.authNewPasswordLabel,
                  keyboardType: .visiblePassword,
                  textInputAction: .next,
                  prefixIconData: AppIcons.newLock,
                  suffixIconData: _obscureNew ? AppIcons.eye : AppIcons.eyeOff,
                  suffixIconOnClick: _toggleNewVisibility,
                  controller: _newPasswordController,
                  obscureText: _obscureNew,
                  validatorFunction: (value) {
                    if ((value ?? "").length < 8) {
                      return l10n.validationPasswordTooShort;
                    }
                    return null;
                  },
                ),
                AppSpacing.gapVLg,
                AppTextFormField(
                  isRequired: true,
                  labelText: l10n.authConfirmNewPasswordLabel,
                  keyboardType: .visiblePassword,
                  textInputAction: .done,
                  prefixIconData: AppIcons.lock,
                  suffixIconData: _obscureConfirm
                      ? AppIcons.eye
                      : AppIcons.eyeOff,
                  suffixIconOnClick: _toggleConfirmVisibility,
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  validatorFunction: (value) {
                    if ((value ?? "") != _newPasswordController.text) {
                      return l10n.validationPasswordsDoNotMatch;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          AppSpacing.gapVXxl,
          AppElevatedButton(
            text: l10n.commonSave,
            isLoading: _isLoading,
            onPressed: _changePassword,
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final result = await ref
        .read(updatePasswordUseCaseProvider)
        .call(_newPasswordController.text);
    if (mounted) setState(() => _isLoading = false);
    if (!mounted) return;
    result.fold(
      (error) => context.showError(context.localizeFailure(error)),
      (_) {
        context.showSuccess(context.l10n.authPasswordUpdateSuccess);
        context.popScreen();
      },
    );
  }

  void _toggleNewVisibility() => setState(() => _obscureNew = !_obscureNew);

  void _toggleConfirmVisibility() =>
      setState(() => _obscureConfirm = !_obscureConfirm);
}
