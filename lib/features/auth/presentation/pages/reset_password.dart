import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/failure_extensions.dart";
import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show
        AppScaffold,
        AppTopbar,
        AppTextFormField,
        AppElevatedButton,
        AppOutlinedButton;
import "../providers/auth_providers.dart";
import "../widgets/index.dart";

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
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
    final tt = context.textTheme;
    return AppScaffold(
      body: Column(
        children: [
          const AppTopbar(title: ""),
          AppSpacing.gapVSm,
          AuthPageTitle(
            title: l10n.authResetPasswordTitle,
            subtitle: l10n.authResetPasswordSubtitle,
            tt: tt,
          ),
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
          Column(
            spacing: AppSpacing.sm,
            children: [
              AppElevatedButton(
                text: l10n.authResetPasswordButton,
                isLoading: _isLoading,
                onPressed: _resetPassword,
              ),
              AppOutlinedButton(
                onPressed: () => context.goAuthLogin(),
                text: l10n.authBackToLogin,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final result = await ref
        .read(updatePasswordUseCaseProvider)
        .call(_newPasswordController.text);
    if (mounted) setState(() => _isLoading = false);
    result.fold(
      (error) => context.showSnackBar(context.localizeFailure(error)),
      (_) {
        context.showSuccess(context.l10n.authPasswordUpdateSuccess);
        context.goAuthLogin();
      },
    );
  }

  void _toggleNewVisibility() => setState(() => _obscureNew = !_obscureNew);

  void _toggleConfirmVisibility() =>
      setState(() => _obscureConfirm = !_obscureConfirm);
}
