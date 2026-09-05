import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_assets.dart";
import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/failure_extensions.dart";
import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_spacing.dart";
import "../../../../core/utils/utils.dart";
import "../../../../features/auth/presentation/widgets/index.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show
        AppScaffold,
        AppTopbar,
        AppTextFormField,
        AppElevatedButton,
        AppDivider;
import "../../domain/entities/auth_state.dart";
import "../providers/auth_providers.dart";

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late GlobalKey<FormState> _formKey;
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
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tt = context.textTheme;
    final cs = context.colorScheme;
    final authState = ref.watch(authProvider);
    final isOAuthLoading = switch (authState) {
      AuthOAuthPending() || AuthLoading() when !_isLoading => true,
      _ => false,
    };
    return AppScaffold(
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: isOAuthLoading,
            child: Column(
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
            title: l10n.authLoginTitle,
            subtitle: l10n.authLoginSubtitle,
            tt: tt,
          ),
          AppSpacing.gapVXxl,
          Form(
            key: _formKey,
            child: Column(
              children: [
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
                Align(
                  alignment: .centerEnd,
                  child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(
                      l10n.authForgotPasswordLink,
                      style: tt.labelLarge!.copyWith(
                        color: cs.primary,
                        fontWeight: .bold,
                      ),
                    ),
                    onPressed: () => context.pushAuthForgot<void>(),
                  ),
                ),
              ],
            ),
          ),
          Column(
            spacing: AppSpacing.sm,
            children: [
              AppElevatedButton(
                text: l10n.authLoginButton,
                isLoading: _isLoading,
                onPressed: _login,
              ),
              RichText(
                text: TextSpan(
                  text: "${l10n.authNoAccount} ",
                  style: tt.bodyMedium,
                  children: [
                    TextSpan(
                      text: l10n.authSignupLink,
                      style: tt.bodyMedium!.copyWith(
                        color: cs.primary,
                        fontWeight: .bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.pushAuthSignup<void>(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapVXxxl,
          AppSpacing.gapVXxl,
          AppDivider(label: l10n.authOrContinueWith),
          AppSpacing.gapVXxxl,
          OauthButtonsRow(oauthProviders: _getProviders()),
              ],
            ),
          ),
          if (isOAuthLoading)
            Positioned.fill(
              child: ColoredBox(
                color: cs.surface.withValues(alpha: 0.75),
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
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
    await ref.read(authProvider.notifier).signInWithGoogle();
    if (!mounted) return;
    final authState = ref.read(authProvider);
    if (authState case AuthFailureState(:final failure)) {
      context.showSnackBar(context.localizeFailure(failure));
    }
  }

  Future<void> _githubLogin() async {
    await ref.read(authProvider.notifier).signInWithGithub();
    if (!mounted) return;
    final authState = ref.read(authProvider);
    if (authState case AuthFailureState(:final failure)) {
      context.showSnackBar(context.localizeFailure(failure));
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await ref
        .read(authProvider.notifier)
        .login(_emailController.text, _passwordController.text);
    if (mounted) setState(() => _isLoading = false);
    if (!mounted) return;
    switch (ref.read(authProvider)) {
      case AuthFailureState(:final failure):
        context.showSnackBar(context.localizeFailure(failure));
      case AuthAuthenticated(:final profile):
        context.showSnackBar(context.l10n.authLoginSuccess(profile.username));
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
      if (mounted) context.goHome();
    }
  }

  void _togglePasswordVisibility() =>
      setState(() => _obscurePassword = !_obscurePassword);
}
