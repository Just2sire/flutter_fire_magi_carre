import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:magi_carre/shared/presentation/widgets/buttons/app_outlined_button.dart";

import "../../../../core/constants/app_assets.dart";
import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/failure_extensions.dart";
import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_spacing.dart";
import "../../../../core/utils/utils.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar, AppTextFormField, AppElevatedButton;
import "../providers/auth_providers.dart";
import "../widgets/index.dart";

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailController;
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _emailSent = false;
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
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
          if (_emailSent)
            const _ForgotPasswordConfirmation()
          else ...[
            AuthPageTitle(
              title: l10n.authForgotPasswordTitle,
              subtitle: l10n.authForgotPasswordSubtitle,
              tt: tt,
            ),
            AppSpacing.gapVXxl,
            Form(
              key: _formKey,
              child: AppTextFormField(
                isRequired: true,
                autoFocus: true,
                labelText: l10n.authEmailLabel,
                keyboardType: .emailAddress,
                textInputAction: .done,
                prefixIconData: AppIcons.mail,
                controller: _emailController,
                validatorFunction: (value) {
                  if (!AppUtils.isValidEmail(value ?? "")) {
                    return l10n.validationInvalidEmail;
                  }
                  return null;
                },
              ),
            ),
            AppSpacing.gapVXxl,
            Column(
              spacing: AppSpacing.sm,
              children: [
                AppElevatedButton(
                  text: l10n.authForgotPasswordButton,
                  isLoading: _isLoading,
                  onPressed: _sendResetLink,
                ),
                AppOutlinedButton(
                  onPressed: () => context.popScreen(),
                  text: l10n.authBackToLogin,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final result = await ref
        .read(resetPasswordUseCaseProvider)
        .call(_emailController.text);
    if (mounted) setState(() => _isLoading = false);
    result.fold(
      (error) => context.showSnackBar(context.localizeFailure(error)),
      (_) => setState(() => _emailSent = true),
    );
  }
}

class _ForgotPasswordConfirmation extends StatelessWidget {
  const _ForgotPasswordConfirmation();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tt = context.textTheme;
    return Column(
      children: [
        AppSpacing.gapVXxl,
        Image.asset(
          AppAssets.mailSent,
          width: AppSpacing.yotta * 3,
          height: AppSpacing.yotta * 3,
        ),
        AppSpacing.gapVLg,
        AuthPageTitle(
          title: l10n.authCheckEmailTitle,
          subtitle: l10n.authCheckEmailSubtitle,
          tt: tt,
        ),
        AppSpacing.gapVXxl,
        AppElevatedButton(
          text: l10n.authBackToLogin,
          onPressed: () => context.goAuthLogin(),
        ),
      ],
    );
  }
}
