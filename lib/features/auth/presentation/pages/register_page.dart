import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_assets.dart";
import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/extensions/failure_extensions.dart";
import "../../../../core/extensions/navigation_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../core/utils/utils.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show
        AppScaffold,
        AppTopbar,
        AppTextFormField,
        AppElevatedButton,
        AppDivider;
import "../../domain/entities/auth_state.dart";
import "../providers/auth_providers.dart";
import "../widgets/index.dart";

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late bool _obscurePassword;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _obscurePassword = true;
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tt = context.textTheme;
    final cs = context.colorScheme;
    return AppScaffold(
      body: Column(
        crossAxisAlignment: .start,
        children: [
          AppTopbar(
            leadingButtonTooltip: l10n.authSkipTitle,
            title: "",
            actions: [
              Tooltip(
                message: l10n.onboardingSkip,
                child: TextButton(
                  onPressed: _skipAuth,
                  child: Text(l10n.authSkipTitle, style: tt.labelLarge),
                ),
              ),
            ],
          ),
          AppSpacing.gapVSm,
          AuthPageTitle(
            title: l10n.authSignupTitle,
            subtitle: l10n.authSignupSubtitle,
            tt: tt,
          ),
          AppSpacing.gapVXxl,
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextFormField(
                  isRequired: true,
                  labelText: l10n.authUsernameLabel,
                  keyboardType: .name,
                  textInputAction: .next,
                  prefixIconData: AppIcons.user,
                  controller: _usernameController,
                  validatorFunction: (value) {
                    final input = value ?? "";
                    if (input.length < 3) {
                      return l10n.validationUsernameTooShort(3);
                    } else if (input.length > 20) {
                      return l10n.validationUsernameTooLong(20);
                    }
                    return null;
                  },
                ),
                AppSpacing.gapVLg,
                AppTextFormField(
                  isRequired: true,
                  labelText: l10n.authEmailLabel,
                  keyboardType: .emailAddress,
                  textInputAction: .next,
                  prefixIconData: AppIcons.mail,
                  controller: _emailController,
                  validatorFunction: (value) {
                    if (!AppUtils.isValidEmail(value ?? "")) {
                      return l10n.validationInvalidEmail;
                    }
                    return null;
                  },
                ),
                AppSpacing.gapVLg,
                AppTextFormField(
                  isRequired: true,
                  labelText: l10n.authPasswordLabel,
                  keyboardType: .visiblePassword,
                  textInputAction: .done,
                  prefixIconData: AppIcons.lock,
                  suffixIconData: _obscurePassword
                      ? AppIcons.eye
                      : AppIcons.eyeOff,
                  suffixIconOnClick: _togglePasswordVisibility,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validatorFunction: (value) {
                    if ((value ?? "").length < 6) {
                      return l10n.authPasswordHint(6);
                    }
                    return null;
                  },
                ),
                AppSpacing.gapVXxl,
              ],
            ),
          ),
          Column(
            spacing: AppSpacing.sm,
            children: [
              AppElevatedButton(
                text: l10n.authSignupButton,
                isLoading: _isLoading,
                onPressed: _signUp,
              ),
              RichText(
                text: TextSpan(
                  text: "${l10n.authAlreadyHaveAccount} ",
                  style: tt.bodyMedium,
                  children: [
                    TextSpan(
                      text: l10n.authLoginLink,
                      style: tt.bodyMedium!.copyWith(
                        color: cs.primary,
                        fontWeight: .bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.goAuthLogin(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapVXxl,
          AppSpacing.gapVXxl,
          AppDivider(label: l10n.authOrContinueWith),
          AppSpacing.gapVXxxl,
          OauthButtonsRow(oauthProviders: _getProviders()),
        ],
      ),
    );
  }

  List<OauthProviderInfo> _getProviders() {
    return <OauthProviderInfo>[
      (
        provider: "Google",
        image: AppAssets.googleLogo,
        label: "Google",
        onPressed: _googleSignUp,
      ),
      (
        provider: "GitHub",
        image: context.isDarkMode
            ? AppAssets.githubDarkLogo
            : AppAssets.githubLightLogo,
        label: "GitHub",
        onPressed: _githubLogin,
      ),
    ];
  }

  Future<void> _googleSignUp() async {
    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).signInWithGoogle();
    if (mounted) setState(() => _isLoading = false);
    if (!mounted) return;
    final state = ref.read(authProvider);
    if (state case AuthFailureState(:final failure)) {
      context.showSnackBar(context.localizeFailure(failure));
    }
  }

  Future<void> _githubLogin() async {
    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).signInWithGithub();
    if (mounted) setState(() => _isLoading = false);
    if (!mounted) return;
    final state = ref.read(authProvider);
    if (state case AuthFailureState(:final failure)) {
      context.showSnackBar(context.localizeFailure(failure));
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await ref
        .read(authProvider.notifier)
        .signup(
          _emailController.text,
          _passwordController.text,
          username: _usernameController.text,
        );
    if (mounted) setState(() => _isLoading = false);
    if (!mounted) return;
    switch (ref.read(authProvider)) {
      case AuthFailureState(:final failure):
        context.showSnackBar(context.localizeFailure(failure));
      case AuthAuthenticated(:final profile):
        context.showSnackBar(
          context.l10n.authSignupSuccess(profile.username),
        );
      default:
        break;
    }
  }

  Future<void> _skipAuth() async {
    final confirmed = await context.showConfirmDialog(
      title: context.l10n.authSkipTitle,
      content: context.l10n.authSkipMessage,
      confirmLabel: context.l10n.authSkipConfirm,
      cancelLabel: context.l10n.authSkipCancel,
    );
    if (confirmed == true && mounted) {
      ref.read(authProvider.notifier).skipAuth();
    }
  }

  void _togglePasswordVisibility() =>
      setState(() => _obscurePassword = !_obscurePassword);
}
