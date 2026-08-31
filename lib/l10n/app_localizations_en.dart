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
  String get authOrContinueWith => 'Or continue with';

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
  String authPasswordHint(int length) {
    return 'At least $length characters';
  }

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
  String get authOAuthLoading => 'Signing in…';

  @override
  String get authOAuthCancelled => 'Sign-in cancelled.';

  @override
  String authOAuthFailed(String provider) {
    return 'Failed to sign in with $provider. Try again.';
  }

  @override
  String authOAuthSuccess(String provider) {
    return 'Signed in with $provider successfully!';
  }

  @override
  String get authOAuthSuccessGoogle => 'Signed in with Google successfully!';

  @override
  String get authOAuthSuccessGithub => 'Signed in with GitHub successfully!';

  @override
  String get authOAuthErrorGoogle =>
      'Failed to sign in with Google. Try again.';

  @override
  String get authOAuthErrorGithub =>
      'Failed to sign in with GitHub. Try again.';

  @override
  String get authOAuthCancelledGoogle => 'Google sign-in cancelled.';

  @override
  String get authOAuthCancelledGithub => 'GitHub sign-in cancelled.';

  @override
  String get authContinue => 'Continue';

  @override
  String get authCompleteProfileTitle => 'Complete your profile';

  @override
  String get authCompleteProfileSubtitle =>
      'Choose a username to appear in the game.';

  @override
  String get authCompleteProfileButton => 'Done';

  @override
  String get authUsernameHint => 'E.g. MagiMaster, Player_123456';

  @override
  String get authUsernameHelper => 'Leave empty to auto-generate.';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authBackToLogin => 'Back to sign in';

  @override
  String get authCheckEmailTitle => 'Check your email';

  @override
  String get authCheckEmailSubtitle =>
      'If an account exists, you will receive a reset link.';

  @override
  String get authForgotPasswordSuccess => 'Link sent! Check your inbox.';

  @override
  String get authResetPasswordSubtitle => 'Choose a new secure password.';

  @override
  String get authNewPasswordLabel => 'New password';

  @override
  String get authNewPasswordHint =>
      'At least 8 characters, 1 uppercase, 1 number';

  @override
  String get authConfirmNewPasswordLabel => 'Confirm new password';

  @override
  String get authResetSuccessTitle => 'Password updated!';

  @override
  String get authResetSuccessMessage =>
      'You can now sign in with your new password.';

  @override
  String get authInvalidResetLink =>
      'Invalid or expired link. Request a new one.';

  @override
  String get authPasswordUpdateSuccess => 'Password changed successfully.';

  @override
  String get authVerifyEmailTitle => 'Check your inbox';

  @override
  String authVerifyEmailSubtitle(String email) {
    return 'A verification link has been sent to $email.';
  }

  @override
  String get authResendEmail => 'Resend email';

  @override
  String authSignupSuccess(String username) {
    return 'Account created! Welcome $username!';
  }

  @override
  String get authLogout => 'Sign out';

  @override
  String get authLogoutButton => 'Sign out';

  @override
  String get authLogoutConfirmTitle => 'Sign out?';

  @override
  String get authLogoutConfirmMessage => 'Are you sure you want to sign out?';

  @override
  String get authLogoutSuccess => 'Signed out successfully.';

  @override
  String authLoginSuccess(String username) {
    return 'Welcome back, $username!';
  }

  @override
  String get authLoginError => 'Failed to sign in. Check your credentials.';

  @override
  String get authSignupError => 'Failed to create account. Try again.';

  @override
  String get authLogoutError => 'Failed to sign out. Try again.';

  @override
  String get authResendSuccess => 'Email resent!';

  @override
  String get authResendError => 'Failed to send email. Try again.';

  @override
  String authCompleteProfileSuccess(String username) {
    return 'Profile completed! Welcome $username!';
  }

  @override
  String get authVerifySuccessTitle => 'Email verified!';

  @override
  String get authVerifySuccessMessage =>
      'Your email address has been verified successfully.';

  @override
  String get authGenericSuccess => 'Operation successful.';

  @override
  String get authGenericError => 'Something went wrong. Try again.';

  @override
  String get authErrorInvalidCredentials =>
      'Invalid credentials. Check your email and password.';

  @override
  String get authErrorSessionExpired =>
      'Session expired. Please sign in again.';

  @override
  String get authErrorUnauthorized => 'Unauthorized access.';

  @override
  String get authErrorUserNotFound => 'User not found.';

  @override
  String get authErrorOAuthCancelled => 'Sign-in cancelled.';

  @override
  String get authErrorGoogleCancelled => 'Google sign-in cancelled.';

  @override
  String get authErrorUsernameTaken => 'This username is already taken.';

  @override
  String get authErrorWeakPassword => 'Password is too weak.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Try again in a few minutes.';

  @override
  String get authEmailAlreadyExists =>
      'An account already exists with this email.';

  @override
  String get authTermsPrefix => 'By creating an account, you agree to our';

  @override
  String get authTermsLink => 'Terms of Service';

  @override
  String get authTermsAnd => 'and our';

  @override
  String get authPrivacyLink => 'Privacy Policy';

  @override
  String get authTermsSuffix => '.';

  @override
  String get authSkipTitle => 'Continue without an account?';

  @override
  String get authSkipMessage =>
      'Without an account, you won\'t be able to play online, save your progress or appear on the leaderboard. You can still play offline.';

  @override
  String get authSkipConfirm => 'Continue as guest';

  @override
  String get authSkipCancel => 'Create an account';

  @override
  String get authGuestWarning => 'Guest mode — progress not saved';

  @override
  String get authOnlineRequiresAccount =>
      'An account is required to play online.';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String get validationInvalidEmail => 'Invalid email address.';

  @override
  String get validationEmailIncorrect => 'Incorrect email address.';

  @override
  String get validationPasswordTooShort =>
      'Password must be at least 8 characters.';

  @override
  String get validationPasswordsDoNotMatch => 'Passwords do not match.';

  @override
  String validationUsernameTooShort(int minLength) {
    return 'At least $minLength characters.';
  }

  @override
  String validationUsernameTooLong(int maxLength) {
    return '$maxLength characters max.';
  }

  @override
  String get validationUsernameInvalid => 'Letters, numbers and _ only.';

  @override
  String get routerErrorTitle => 'This screen does not exist yet.';

  @override
  String get routerErrorSubtitle => 'Come back later, or return to home.';

  @override
  String routerSoon(String title) {
    return '$title — coming soon.';
  }

  @override
  String get errorNetwork => 'Network error. Check your internet connection.';

  @override
  String get errorServer => 'Server error. Try again later.';

  @override
  String get errorValidation => 'Invalid data. Check the fields.';

  @override
  String get errorUnknown => 'An unknown error occurred.';

  @override
  String get navHome => 'Home';

  @override
  String get navLobby => 'Lobby';

  @override
  String get navLeaderboard => 'Leaderboard';

  @override
  String get navProfile => 'Profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLogout => 'Log out';

  @override
  String get settingsLogoutConfirmTitle => 'Log out?';

  @override
  String get settingsLogoutConfirmMessage =>
      'You\'ll need to sign in again to access your account.';

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get profileEditUsernameLabel => 'Username';

  @override
  String get profileEditBioLabel => 'Bio';

  @override
  String get profileUpdateSuccess => 'Profile updated successfully.';

  @override
  String get profileAvatarChangeCta => 'Change photo';

  @override
  String get profileChangePasswordCta => 'Change password';

  @override
  String get profileRatingLabel => 'Rating';

  @override
  String get profileFriendsLabel => 'Friends';

  @override
  String get profileGuestMessage => 'Sign in to access your profile.';

  @override
  String get profileGuestCta => 'Sign in';
}
