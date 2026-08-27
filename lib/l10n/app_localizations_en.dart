// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MagiCarré';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSave => 'Save';

  @override
  String get commonClose => 'Close';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonNetworkError => 'No connection. Check your internet.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get authLoginTitle => 'Sign in';

  @override
  String get authLoginSubtitle => 'Sign in to join the game.';

  @override
  String get authLoginButton => 'Sign in';

  @override
  String get authSignupTitle => 'Create an account';

  @override
  String get authSignupSubtitle => 'Join the MagiCarré community.';

  @override
  String get authSignupButton => 'Sign up';

  @override
  String get authForgotPasswordTitle => 'Forgot password';

  @override
  String get authForgotPasswordSubtitle =>
      'Enter your email address to receive a reset link.';

  @override
  String get authForgotPasswordButton => 'Send link';

  @override
  String get authResetPasswordTitle => 'New password';

  @override
  String get authResetPasswordButton => 'Reset';

  @override
  String get authEmailLabel => 'Email address';

  @override
  String get authEmailHint => 'you@email.com';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => 'At least 8 characters';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authUsernameLabel => 'Username';

  @override
  String get authForgotPasswordLink => 'Forgot password?';

  @override
  String get authAlreadyHaveAccount => 'Already have an account?';

  @override
  String get authNoAccount => 'No account yet?';

  @override
  String get authLoginLink => 'Sign in';

  @override
  String get authSignupLink => 'Create an account';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String get validationInvalidEmail => 'Invalid email address.';

  @override
  String get validationPasswordTooShort =>
      'Password must be at least 8 characters.';

  @override
  String get validationPasswordsDoNotMatch => 'Passwords do not match.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';
}
