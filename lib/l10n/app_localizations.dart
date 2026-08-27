import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// Nom de l'application
  ///
  /// In fr, this message translates to:
  /// **'MagiCarré'**
  String get appName;

  /// Libellé du bouton de validation générique
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// Libellé du bouton d'annulation
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonCancel;

  /// Libellé du bouton de confirmation
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get commonConfirm;

  /// Libellé du bouton de nouvelle tentative
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get commonRetry;

  /// Libellé du bouton de sauvegarde
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get commonSave;

  /// Libellé du bouton de fermeture
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get commonClose;

  /// Libellé du bouton de navigation vers l'étape suivante
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get commonNext;

  /// Libellé du bouton de retour
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get commonBack;

  /// Message affiché pendant le chargement
  ///
  /// In fr, this message translates to:
  /// **'Chargement…'**
  String get commonLoading;

  /// Message d'erreur générique
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get commonError;

  /// Message d'erreur réseau
  ///
  /// In fr, this message translates to:
  /// **'Connexion indisponible. Vérifie ta connexion internet.'**
  String get commonNetworkError;

  /// Séparateur générique entre deux options (ex: entre formulaire et OAuth)
  ///
  /// In fr, this message translates to:
  /// **'Ou'**
  String get commonOr;

  /// Bouton pour ignorer l'onboarding
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get onboardingSkip;

  /// Bouton de fin d'onboarding (dernier slide)
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get onboardingGetStarted;

  /// Titre du slide 1 d'onboarding — héritage togolais
  ///
  /// In fr, this message translates to:
  /// **'L\'héritage du MagiCarré'**
  String get onboardingTitle1;

  /// Description du slide 1 — invite à redécouvrir le patrimoine ludique
  ///
  /// In fr, this message translates to:
  /// **'Redécouvre le jeu de stratégie togolais qui rassemble les générations autour d\'un même carré.'**
  String get onboardingDescription1;

  /// Titre du slide 2 d'onboarding — jeu multijoueur
  ///
  /// In fr, this message translates to:
  /// **'Défie tes proches, où que tu sois'**
  String get onboardingTitle2;

  /// Description du slide 2 — création de partie et invitation
  ///
  /// In fr, this message translates to:
  /// **'Crée une partie, invite un ami et joue en temps réel, à la maison ou à distance.'**
  String get onboardingDescription2;

  /// Titre du slide 3 d'onboarding — progression et compétition
  ///
  /// In fr, this message translates to:
  /// **'Grimpe au classement'**
  String get onboardingTitle3;

  /// Description du slide 3 — suivi des victoires et maîtrise
  ///
  /// In fr, this message translates to:
  /// **'Suis tes victoires, progresse à chaque partie et deviens maître du carré.'**
  String get onboardingDescription3;

  /// Label d'accessibilité pour l'indicateur de progression de l'onboarding
  ///
  /// In fr, this message translates to:
  /// **'Page {current} sur {total}'**
  String onboardingProgressLabel(int current, int total);

  /// Titre de la notification affichée à la fin de l'onboarding
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur {appName}'**
  String onboardingNotificationTitle(String appName);

  /// Corps de la notification de fin d'onboarding
  ///
  /// In fr, this message translates to:
  /// **'Ton plateau t\'attend — lance ta première partie dès maintenant.'**
  String get onboardingNotificationBody;

  /// Titre de la page de connexion
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get authLoginTitle;

  /// Sous-titre de la page de connexion
  ///
  /// In fr, this message translates to:
  /// **'Connecte-toi pour rejoindre la partie.'**
  String get authLoginSubtitle;

  /// Libellé du bouton de connexion
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authLoginButton;

  /// Titre de la page d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authSignupTitle;

  /// Sous-titre de la page d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Rejoins la communauté MagiCarré.'**
  String get authSignupSubtitle;

  /// Libellé du bouton d'inscription
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get authSignupButton;

  /// Titre de la page de mot de passe oublié
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié'**
  String get authForgotPasswordTitle;

  /// Sous-titre de la page de mot de passe oublié
  ///
  /// In fr, this message translates to:
  /// **'Saisis ton adresse e-mail pour recevoir un lien de réinitialisation.'**
  String get authForgotPasswordSubtitle;

  /// Libellé du bouton d'envoi du lien de réinitialisation
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le lien'**
  String get authForgotPasswordButton;

  /// Titre de la page de réinitialisation du mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get authResetPasswordTitle;

  /// Libellé du bouton de réinitialisation du mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get authResetPasswordButton;

  /// Label du champ e-mail
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get authEmailLabel;

  /// Placeholder du champ e-mail
  ///
  /// In fr, this message translates to:
  /// **'ton@email.com'**
  String get authEmailHint;

  /// Label du champ mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get authPasswordLabel;

  /// Placeholder du champ mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Au moins 8 caractères'**
  String get authPasswordHint;

  /// Label du champ de confirmation de mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get authConfirmPasswordLabel;

  /// Label du champ nom d'utilisateur
  ///
  /// In fr, this message translates to:
  /// **'Nom d\'utilisateur'**
  String get authUsernameLabel;

  /// Lien vers la page de récupération de mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get authForgotPasswordLink;

  /// Texte précédant le lien vers la page de connexion
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ?'**
  String get authAlreadyHaveAccount;

  /// Texte précédant le lien vers la page d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get authNoAccount;

  /// Lien vers la page de connexion
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authLoginLink;

  /// Lien vers la page d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authSignupLink;

  /// Bouton OAuth — continuer avec Google
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get authOAuthGoogle;

  /// Bouton OAuth — continuer avec GitHub
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec GitHub'**
  String get authOAuthGithub;

  /// Bouton OAuth — continuer avec Apple
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Apple'**
  String get authOAuthApple;

  /// Message d'erreur pour un champ obligatoire vide
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est obligatoire.'**
  String get validationRequired;

  /// Message d'erreur pour un e-mail mal formaté
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail invalide.'**
  String get validationInvalidEmail;

  /// Message d'erreur pour un mot de passe trop court
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 8 caractères.'**
  String get validationPasswordTooShort;

  /// Message d'erreur quand les deux mots de passe diffèrent
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas.'**
  String get validationPasswordsDoNotMatch;

  /// Label de la section de choix de la langue dans les paramètres
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// Libellé de l'option langue française
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsLanguageFr;

  /// Libellé de l'option langue anglaise
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
