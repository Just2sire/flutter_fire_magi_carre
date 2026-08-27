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
  String get commonOr => 'Or';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingTitle1 => 'The heritage of MagiCarré';

  @override
  String get onboardingDescription1 =>
      'Rediscover the Togolese strategy game that brings generations together around the same board.';

  @override
  String get onboardingTitle2 => 'Challenge your friends, wherever you are';

  @override
  String get onboardingDescription2 =>
      'Create a game, invite a friend and play in real time, at home or away.';

  @override
  String get onboardingTitle3 => 'Climb the ranks';

  @override
  String get onboardingDescription3 =>
      'Track your wins, improve with every game and become a master of the board.';

  @override
  String onboardingProgressLabel(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String onboardingNotificationTitle(String appName) {
    return 'Welcome to $appName';
  }

  @override
  String get onboardingNotificationBody =>
      'Your board awaits — start your first game now.';

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
  String get authOAuthGoogle => 'Continue with Google';

  @override
  String get authOAuthGithub => 'Continue with GitHub';

  @override
  String get authOAuthApple => 'Continue with Apple';

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
