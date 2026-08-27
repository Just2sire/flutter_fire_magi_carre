// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'MagiCarré';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonLoading => 'Chargement…';

  @override
  String get commonError => 'Une erreur est survenue';

  @override
  String get commonNetworkError =>
      'Connexion indisponible. Vérifie ta connexion internet.';

  @override
  String get commonOr => 'Ou';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingTitle1 => 'L\'héritage du MagiCarré';

  @override
  String get onboardingDescription1 =>
      'Redécouvre le jeu de stratégie togolais qui rassemble les générations autour d\'un même carré.';

  @override
  String get onboardingTitle2 => 'Défie tes proches, où que tu sois';

  @override
  String get onboardingDescription2 =>
      'Crée une partie, invite un ami et joue en temps réel, à la maison ou à distance.';

  @override
  String get onboardingTitle3 => 'Grimpe au classement';

  @override
  String get onboardingDescription3 =>
      'Suis tes victoires, progresse à chaque partie et deviens maître du carré.';

  @override
  String onboardingProgressLabel(int current, int total) {
    return 'Page $current sur $total';
  }

  @override
  String onboardingNotificationTitle(String appName) {
    return 'Bienvenue sur $appName';
  }

  @override
  String get onboardingNotificationBody =>
      'Ton plateau t\'attend — lance ta première partie dès maintenant.';

  @override
  String get authLoginTitle => 'Connexion';

  @override
  String get authLoginSubtitle => 'Connecte-toi pour rejoindre la partie.';

  @override
  String get authLoginButton => 'Se connecter';

  @override
  String get authSignupTitle => 'Créer un compte';

  @override
  String get authSignupSubtitle => 'Rejoins la communauté MagiCarré.';

  @override
  String get authSignupButton => 'S\'inscrire';

  @override
  String get authForgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get authForgotPasswordSubtitle =>
      'Saisis ton adresse e-mail pour recevoir un lien de réinitialisation.';

  @override
  String get authForgotPasswordButton => 'Envoyer le lien';

  @override
  String get authResetPasswordTitle => 'Nouveau mot de passe';

  @override
  String get authResetPasswordButton => 'Réinitialiser';

  @override
  String get authEmailLabel => 'Adresse e-mail';

  @override
  String get authEmailHint => 'ton@email.com';

  @override
  String get authPasswordLabel => 'Mot de passe';

  @override
  String get authPasswordHint => 'Au moins 8 caractères';

  @override
  String get authConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get authUsernameLabel => 'Nom d\'utilisateur';

  @override
  String get authForgotPasswordLink => 'Mot de passe oublié ?';

  @override
  String get authAlreadyHaveAccount => 'Déjà un compte ?';

  @override
  String get authNoAccount => 'Pas encore de compte ?';

  @override
  String get authLoginLink => 'Se connecter';

  @override
  String get authSignupLink => 'Créer un compte';

  @override
  String get authOAuthGoogle => 'Continuer avec Google';

  @override
  String get authOAuthGithub => 'Continuer avec GitHub';

  @override
  String get authOAuthApple => 'Continuer avec Apple';

  @override
  String get validationRequired => 'Ce champ est obligatoire.';

  @override
  String get validationInvalidEmail => 'Adresse e-mail invalide.';

  @override
  String get validationPasswordTooShort =>
      'Le mot de passe doit contenir au moins 8 caractères.';

  @override
  String get validationPasswordsDoNotMatch =>
      'Les mots de passe ne correspondent pas.';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';
}
