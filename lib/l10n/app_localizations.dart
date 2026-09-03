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

  /// Séparateur DIVIDER entre formulaire email/password et boutons OAuth multiples (Google/GitHub/Apple)
  ///
  /// In fr, this message translates to:
  /// **'Ou continuer avec'**
  String get authOrContinueWith;

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
  /// **'Email'**
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
  /// **'Au moins {length} caractères'**
  String authPasswordHint(int length);

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
  /// **'Pas de compte ?'**
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

  /// Texte de chargement pendant l'auth OAuth
  ///
  /// In fr, this message translates to:
  /// **'Connexion en cours…'**
  String get authOAuthLoading;

  /// Message quand l'utilisateur annule le flow OAuth
  ///
  /// In fr, this message translates to:
  /// **'Connexion annulée.'**
  String get authOAuthCancelled;

  /// Message d'échec OAuth avec nom du provider
  ///
  /// In fr, this message translates to:
  /// **'Échec de la connexion {provider}. Réessaie.'**
  String authOAuthFailed(String provider);

  /// Message générique de succès OAuth avec nom du provider
  ///
  /// In fr, this message translates to:
  /// **'Connexion avec {provider} réussie !'**
  String authOAuthSuccess(String provider);

  /// Message de succès OAuth Google
  ///
  /// In fr, this message translates to:
  /// **'Connexion avec Google réussie !'**
  String get authOAuthSuccessGoogle;

  /// Message de succès OAuth GitHub
  ///
  /// In fr, this message translates to:
  /// **'Connexion avec GitHub réussie !'**
  String get authOAuthSuccessGithub;

  /// Message d'erreur OAuth Google
  ///
  /// In fr, this message translates to:
  /// **'Échec de la connexion avec Google. Réessaie.'**
  String get authOAuthErrorGoogle;

  /// Message d'erreur OAuth GitHub
  ///
  /// In fr, this message translates to:
  /// **'Échec de la connexion avec GitHub. Réessaie.'**
  String get authOAuthErrorGithub;

  /// Message d'annulation OAuth Google
  ///
  /// In fr, this message translates to:
  /// **'Connexion Google annulée.'**
  String get authOAuthCancelledGoogle;

  /// Message d'annulation OAuth GitHub
  ///
  /// In fr, this message translates to:
  /// **'Connexion GitHub annulée.'**
  String get authOAuthCancelledGithub;

  /// Libellé du bouton générique Continuer (OAuth complete, etc.)
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get authContinue;

  /// Titre de la page de finalisation du profil après OAuth
  ///
  /// In fr, this message translates to:
  /// **'Finalise ton profil'**
  String get authCompleteProfileTitle;

  /// Sous-titre de la page de finalisation du profil
  ///
  /// In fr, this message translates to:
  /// **'Choisis un nom d\'utilisateur pour apparaître dans le jeu.'**
  String get authCompleteProfileSubtitle;

  /// Bouton de validation de la finalisation du profil
  ///
  /// In fr, this message translates to:
  /// **'Terminer'**
  String get authCompleteProfileButton;

  /// Placeholder du champ nom d'utilisateur
  ///
  /// In fr, this message translates to:
  /// **'Ex : MagiMaster, Player_123456'**
  String get authUsernameHint;

  /// Texte d'aide sous le champ nom d'utilisateur quand génération auto possible
  ///
  /// In fr, this message translates to:
  /// **'Laisse vide pour générer automatiquement.'**
  String get authUsernameHelper;

  /// Tooltip/accessibilité pour afficher le mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Afficher le mot de passe'**
  String get authShowPassword;

  /// Tooltip/accessibilité pour masquer le mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Masquer le mot de passe'**
  String get authHidePassword;

  /// Lien de retour vers la page de connexion depuis forgot/reset
  ///
  /// In fr, this message translates to:
  /// **'Retour à la connexion'**
  String get authBackToLogin;

  /// Titre de l'écran de succès après envoi du lien de réinitialisation
  ///
  /// In fr, this message translates to:
  /// **'Vérifie tes e-mails'**
  String get authCheckEmailTitle;

  /// Sous-titre anti-énumération sur l'écran check email
  ///
  /// In fr, this message translates to:
  /// **'Si un compte existe, tu recevras un lien de réinitialisation.'**
  String get authCheckEmailSubtitle;

  /// Message de succès après demande de réinitialisation
  ///
  /// In fr, this message translates to:
  /// **'Lien envoyé ! Vérifie ta messagerie.'**
  String get authForgotPasswordSuccess;

  /// Sous-titre de la page de réinitialisation du mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Choisis un nouveau mot de passe sécurisé.'**
  String get authResetPasswordSubtitle;

  /// Label du champ nouveau mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get authNewPasswordLabel;

  /// Placeholder du champ nouveau mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Au moins 8 caractères, 1 majuscule, 1 chiffre'**
  String get authNewPasswordHint;

  /// Label du champ de confirmation du nouveau mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le nouveau mot de passe'**
  String get authConfirmNewPasswordLabel;

  /// Titre de l'écran de succès après réinitialisation
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe mis à jour !'**
  String get authResetSuccessTitle;

  /// Message de succès après mise à jour du mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Tu peux maintenant te connecter avec ton nouveau mot de passe.'**
  String get authResetSuccessMessage;

  /// Message quand le lien de réinitialisation est invalide ou expiré
  ///
  /// In fr, this message translates to:
  /// **'Lien invalide ou expiré. Demande un nouveau lien.'**
  String get authInvalidResetLink;

  /// Message de succès après changement de mot de passe depuis le profil
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe modifié avec succès.'**
  String get authPasswordUpdateSuccess;

  /// Titre de l'écran de vérification d'e-mail après inscription
  ///
  /// In fr, this message translates to:
  /// **'Vérifie ta boîte mail'**
  String get authVerifyEmailTitle;

  /// Sous-titre de vérification d'e-mail avec adresse
  ///
  /// In fr, this message translates to:
  /// **'Un lien de vérification a été envoyé à {email}.'**
  String authVerifyEmailSubtitle(String email);

  /// Bouton pour renvoyer l'e-mail de vérification/réinitialisation
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer l\'e-mail'**
  String get authResendEmail;

  /// Message de succès après inscription avec pseudo
  ///
  /// In fr, this message translates to:
  /// **'Compte créé ! Bienvenue {username} !'**
  String authSignupSuccess(String username);

  /// Libellé générique de déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get authLogout;

  /// Bouton de déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get authLogoutButton;

  /// Titre du dialogue de confirmation de déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter ?'**
  String get authLogoutConfirmTitle;

  /// Message du dialogue de confirmation de déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Es-tu sûr de vouloir te déconnecter ?'**
  String get authLogoutConfirmMessage;

  /// Message de succès après déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Déconnecté avec succès.'**
  String get authLogoutSuccess;

  /// Message de succès après connexion
  ///
  /// In fr, this message translates to:
  /// **'Connexion réussie ! Ravie de te revoir, {username} !'**
  String authLoginSuccess(String username);

  /// Message d'erreur générique après échec de connexion
  ///
  /// In fr, this message translates to:
  /// **'Échec de la connexion. Vérifie tes identifiants.'**
  String get authLoginError;

  /// Message d'erreur générique après échec d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'inscription. Réessaie.'**
  String get authSignupError;

  /// Message d'erreur après échec de déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Échec de la déconnexion. Réessaie.'**
  String get authLogoutError;

  /// Message de succès après renvoi d'e-mail
  ///
  /// In fr, this message translates to:
  /// **'E-mail renvoyé !'**
  String get authResendSuccess;

  /// Message d'erreur après échec de renvoi d'e-mail
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'envoyer l\'e-mail. Réessaie.'**
  String get authResendError;

  /// Message de succès après finalisation du profil OAuth
  ///
  /// In fr, this message translates to:
  /// **'Profil complété ! Bienvenue {username} !'**
  String authCompleteProfileSuccess(String username);

  /// Titre de succès après vérification d'e-mail
  ///
  /// In fr, this message translates to:
  /// **'Adresse vérifiée !'**
  String get authVerifySuccessTitle;

  /// Message de succès après vérification d'e-mail
  ///
  /// In fr, this message translates to:
  /// **'Ton adresse e-mail a été vérifiée avec succès.'**
  String get authVerifySuccessMessage;

  /// Message générique de succès
  ///
  /// In fr, this message translates to:
  /// **'Opération réussie.'**
  String get authGenericSuccess;

  /// Message générique d'erreur auth
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Réessaie.'**
  String get authGenericError;

  /// Erreur InvalidCredentialsFailure
  ///
  /// In fr, this message translates to:
  /// **'Identifiants invalides. Vérifie ton e-mail et ton mot de passe.'**
  String get authErrorInvalidCredentials;

  /// Erreur SessionExpiredFailure
  ///
  /// In fr, this message translates to:
  /// **'Session expirée. Veuillez vous reconnecter.'**
  String get authErrorSessionExpired;

  /// Erreur UnauthorizedFailure (403)
  ///
  /// In fr, this message translates to:
  /// **'Accès non autorisé.'**
  String get authErrorUnauthorized;

  /// Erreur UserNotFoundFailure
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur introuvable.'**
  String get authErrorUserNotFound;

  /// Erreur OAuthCancelledFailure
  ///
  /// In fr, this message translates to:
  /// **'Connexion annulée.'**
  String get authErrorOAuthCancelled;

  /// Erreur GoogleSignInCancelledFailure
  ///
  /// In fr, this message translates to:
  /// **'Connexion Google annulée.'**
  String get authErrorGoogleCancelled;

  /// Erreur UsernameTakenFailure
  ///
  /// In fr, this message translates to:
  /// **'Ce nom d\'utilisateur est déjà pris.'**
  String get authErrorUsernameTaken;

  /// Erreur mot de passe faible Supabase
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe trop faible.'**
  String get authErrorWeakPassword;

  /// Erreur rate-limit / trop de requêtes
  ///
  /// In fr, this message translates to:
  /// **'Trop de tentatives. Réessaie dans quelques minutes.'**
  String get authErrorTooManyRequests;

  /// Erreur inscription — e-mail déjà utilisé
  ///
  /// In fr, this message translates to:
  /// **'Un compte existe déjà avec cet e-mail.'**
  String get authEmailAlreadyExists;

  /// Préfixe du texte CGU avant le lien Conditions
  ///
  /// In fr, this message translates to:
  /// **'En créant un compte, tu acceptes nos'**
  String get authTermsPrefix;

  /// Lien vers les Conditions d'utilisation
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'utilisation'**
  String get authTermsLink;

  /// Conjonction entre CGU et Politique de confidentialité
  ///
  /// In fr, this message translates to:
  /// **'et notre'**
  String get authTermsAnd;

  /// Lien vers la Politique de confidentialité
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get authPrivacyLink;

  /// Suffixe ponctuation après les liens CGU
  ///
  /// In fr, this message translates to:
  /// **'.'**
  String get authTermsSuffix;

  /// Titre du dialogue d'avertissement quand on skip l'auth
  ///
  /// In fr, this message translates to:
  /// **'Continuer sans compte ?'**
  String get authSkipTitle;

  /// Message d'avertissement skip auth — limitations du mode invité
  ///
  /// In fr, this message translates to:
  /// **'Sans compte, tu ne pourras pas jouer en ligne, sauvegarder ta progression ni apparaître au classement. Tu pourras toujours jouer hors ligne.'**
  String get authSkipMessage;

  /// Bouton confirmer pour continuer sans compte (mode invité)
  ///
  /// In fr, this message translates to:
  /// **'Continuer en invité'**
  String get authSkipConfirm;

  /// Bouton annuler du dialogue skip — redirige vers inscription
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authSkipCancel;

  /// Bannière/chip affichée quand l'utilisateur est en mode invité
  ///
  /// In fr, this message translates to:
  /// **'Mode invité — progression non sauvegardée'**
  String get authGuestWarning;

  /// Titre du bottom sheet d'invite à la connexion pour les invités
  ///
  /// In fr, this message translates to:
  /// **'Connecte-toi pour continuer'**
  String get authGateTitle;

  /// Sous-titre du bottom sheet d'invite à la connexion
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde ta progression, joue en ligne et grimpe au classement.'**
  String get authGateSubtitle;

  /// Bouton de connexion par e-mail dans le gate sheet
  ///
  /// In fr, this message translates to:
  /// **'Se connecter par e-mail'**
  String get authGateLoginWithEmail;

  /// Bouton d'inscription dans le gate sheet
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authGateCreateAccount;

  /// Bouton pour fermer le gate sheet et rester invité
  ///
  /// In fr, this message translates to:
  /// **'Continuer en invité'**
  String get authGateContinueAsGuest;

  /// Message bloquant quand on tente d'accéder au jeu en ligne sans compte
  ///
  /// In fr, this message translates to:
  /// **'Un compte est requis pour jouer en ligne.'**
  String get authOnlineRequiresAccount;

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

  /// Message d'erreur pour un e-mail ne correspondant à aucun compte / incorrect lors de la connexion
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail incorrecte.'**
  String get validationEmailIncorrect;

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

  /// Message d'erreur quand le nom d'utilisateur est trop court
  ///
  /// In fr, this message translates to:
  /// **'Au moins {minLength} caractères.'**
  String validationUsernameTooShort(int minLength);

  /// Message d'erreur quand le nom d'utilisateur est trop long
  ///
  /// In fr, this message translates to:
  /// **'{maxLength} caractères maximum.'**
  String validationUsernameTooLong(int maxLength);

  /// Message d'erreur quand le nom d'utilisateur contient des caractères invalides
  ///
  /// In fr, this message translates to:
  /// **'Lettres, chiffres et _ uniquement.'**
  String get validationUsernameInvalid;

  /// Titre de la page d'erreur de routing
  ///
  /// In fr, this message translates to:
  /// **'Cet écran n\'existe pas encore.'**
  String get routerErrorTitle;

  /// Sous-titre de la page d'erreur de routing
  ///
  /// In fr, this message translates to:
  /// **'Reviens plus tard, ou reprends depuis l\'accueil.'**
  String get routerErrorSubtitle;

  /// Placeholder générique pour écran bientôt disponible
  ///
  /// In fr, this message translates to:
  /// **'{title} — bientôt.'**
  String routerSoon(String title);

  /// Erreur réseau générique (NetworkFailure)
  ///
  /// In fr, this message translates to:
  /// **'Erreur réseau. Vérifie ta connexion internet.'**
  String get errorNetwork;

  /// Erreur serveur générique (ServerFailure)
  ///
  /// In fr, this message translates to:
  /// **'Erreur serveur. Réessaie plus tard.'**
  String get errorServer;

  /// Erreur de validation générique (ValidationFailure)
  ///
  /// In fr, this message translates to:
  /// **'Données invalides. Vérifie les champs.'**
  String get errorValidation;

  /// Erreur inconnue (fallback Failure)
  ///
  /// In fr, this message translates to:
  /// **'Une erreur inconnue est survenue.'**
  String get errorUnknown;

  /// Label de la destination Accueil dans la barre de navigation
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// Label de la destination Lobby dans la barre de navigation
  ///
  /// In fr, this message translates to:
  /// **'Lobby'**
  String get navLobby;

  /// Label de la destination Classement dans la barre de navigation
  ///
  /// In fr, this message translates to:
  /// **'Classement'**
  String get navLeaderboard;

  /// Label de la destination Profil dans la barre de navigation
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// Titre de la page de classement
  ///
  /// In fr, this message translates to:
  /// **'Classement'**
  String get leaderboardTitle;

  /// Sous-titre de la page de classement
  ///
  /// In fr, this message translates to:
  /// **'Les meilleurs joueurs de MagiCarré'**
  String get leaderboardSubtitle;

  /// Label du Top 50 joueurs
  ///
  /// In fr, this message translates to:
  /// **'Top 50'**
  String get leaderboardTop50;

  /// Titre de la section rang personnel
  ///
  /// In fr, this message translates to:
  /// **'Ton rang'**
  String get leaderboardMyRank;

  /// En-tête de colonne Rang
  ///
  /// In fr, this message translates to:
  /// **'Rang'**
  String get leaderboardRank;

  /// En-tête de colonne Joueur
  ///
  /// In fr, this message translates to:
  /// **'Joueur'**
  String get leaderboardPlayer;

  /// En-tête de colonne Score / rating
  ///
  /// In fr, this message translates to:
  /// **'Score'**
  String get leaderboardRating;

  /// Label du rang avec numéro
  ///
  /// In fr, this message translates to:
  /// **'#{rank}'**
  String leaderboardRankLabel(int rank);

  /// Label du score avec points
  ///
  /// In fr, this message translates to:
  /// **'{rating} pts'**
  String leaderboardRatingLabel(int rating);

  /// Badge affiché pour l'utilisateur courant dans la liste
  ///
  /// In fr, this message translates to:
  /// **'Toi'**
  String get leaderboardYou;

  /// Titre de l'état vide du classement
  ///
  /// In fr, this message translates to:
  /// **'Aucun classement disponible'**
  String get leaderboardEmptyTitle;

  /// Sous-titre de l'état vide du classement
  ///
  /// In fr, this message translates to:
  /// **'Sois le premier à grimper au sommet !'**
  String get leaderboardEmptySubtitle;

  /// Titre de l'état d'erreur du classement
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement'**
  String get leaderboardErrorTitle;

  /// Message d'erreur de chargement du classement
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger le classement. Réessaie.'**
  String get leaderboardErrorMessage;

  /// Titre de la page des paramètres
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

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

  /// Label de la section de choix du thème dans les paramètres
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsTheme;

  /// Libellé de l'option thème système
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get settingsThemeSystem;

  /// Libellé de l'option thème clair
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get settingsThemeLight;

  /// Libellé de l'option thème sombre
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get settingsThemeDark;

  /// Libellé du bouton de déconnexion dans les paramètres
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get settingsLogout;

  /// Titre du dialogue de confirmation de déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter ?'**
  String get settingsLogoutConfirmTitle;

  /// Message du dialogue de confirmation de déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Tu devras te reconnecter pour accéder à ton compte.'**
  String get settingsLogoutConfirmMessage;

  /// Libellé de la section Compte (profil, mot de passe, déconnexion)
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get settingsAccountSection;

  /// Titre de la page de profil
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// Titre de la page d'édition du profil
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get profileEditTitle;

  /// Label du champ nom d'utilisateur
  ///
  /// In fr, this message translates to:
  /// **'Nom d\'utilisateur'**
  String get profileEditUsernameLabel;

  /// Label du champ bio
  ///
  /// In fr, this message translates to:
  /// **'Bio'**
  String get profileEditBioLabel;

  /// Message de succès après mise à jour du profil
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour avec succès.'**
  String get profileUpdateSuccess;

  /// Libellé de l'action pour changer l'avatar
  ///
  /// In fr, this message translates to:
  /// **'Changer la photo'**
  String get profileAvatarChangeCta;

  /// Libellé du bouton menant à l'écran de changement de mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Modifier le mot de passe'**
  String get profileChangePasswordCta;

  /// Label du score/rating affiché sur le profil
  ///
  /// In fr, this message translates to:
  /// **'Classement'**
  String get profileRatingLabel;

  /// Label du nombre d'amis affiché sur le profil
  ///
  /// In fr, this message translates to:
  /// **'Amis'**
  String get profileFriendsLabel;

  /// Message affiché sur /profile pour un utilisateur en mode invité
  ///
  /// In fr, this message translates to:
  /// **'Connecte-toi pour accéder à ton profil.'**
  String get profileGuestMessage;

  /// Bouton de connexion affiché sur /profile en mode invité
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get profileGuestCta;

  /// Titre de l'écran de partie locale
  ///
  /// In fr, this message translates to:
  /// **'Duel local'**
  String get gameTitle;

  /// Indicateur affiché pendant le calcul du coup de l'IA
  ///
  /// In fr, this message translates to:
  /// **'L\'IA réfléchit…'**
  String get gameAiThinking;

  /// Titre du sélecteur de difficulté
  ///
  /// In fr, this message translates to:
  /// **'Difficulté de l\'IA'**
  String get gameDifficultyTitle;

  /// Libellé du niveau de difficulté facile
  ///
  /// In fr, this message translates to:
  /// **'Débutant'**
  String get gameDifficultyEasy;

  /// Libellé du niveau de difficulté moyen
  ///
  /// In fr, this message translates to:
  /// **'Intermédiaire'**
  String get gameDifficultyMedium;

  /// Libellé du niveau de difficulté difficile
  ///
  /// In fr, this message translates to:
  /// **'Expert'**
  String get gameDifficultyHard;

  /// Titre du dialogue de fin de partie — le joueur gagne
  ///
  /// In fr, this message translates to:
  /// **'Victoire !'**
  String get gameOverWhiteWinsTitle;

  /// Message du dialogue de fin de partie — le joueur gagne
  ///
  /// In fr, this message translates to:
  /// **'Tu as gagné la partie.'**
  String get gameOverWhiteWinsMessage;

  /// Titre du dialogue de fin de partie — l'IA gagne
  ///
  /// In fr, this message translates to:
  /// **'Défaite'**
  String get gameOverBlackWinsTitle;

  /// Message du dialogue de fin de partie — l'IA gagne
  ///
  /// In fr, this message translates to:
  /// **'L\'IA a gagné cette partie.'**
  String get gameOverBlackWinsMessage;

  /// Titre du dialogue de fin de partie — match nul
  ///
  /// In fr, this message translates to:
  /// **'Match nul'**
  String get gameOverDrawTitle;

  /// Message du dialogue de fin de partie — match nul
  ///
  /// In fr, this message translates to:
  /// **'Aucun joueur n\'a pu l\'emporter.'**
  String get gameOverDrawMessage;

  /// Bouton pour relancer une nouvelle partie
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle partie'**
  String get gameNewGameCta;

  /// Bouton pour quitter l'écran de partie
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get gameQuitCta;

  /// Nom du camp noir (IA)
  ///
  /// In fr, this message translates to:
  /// **'Noirs'**
  String get gamePlayerBlack;

  /// Nom du camp blanc (joueur)
  ///
  /// In fr, this message translates to:
  /// **'Blancs'**
  String get gamePlayerWhite;

  /// Nombre de pions capturés par un joueur
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 pion capturé} =1{1 pion capturé} other{{count} pions capturés}}'**
  String gamePiecesCaptured(int count);

  /// Tooltip du bouton d'annulation du dernier coup
  ///
  /// In fr, this message translates to:
  /// **'Annuler le dernier coup'**
  String get gameUndoCta;

  /// Tooltip du bouton de redémarrage de la partie
  ///
  /// In fr, this message translates to:
  /// **'Recommencer la partie'**
  String get gameRestartCta;

  /// Libellé court du badge d'édition sur la carte de profil
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get profileEditCta;

  /// Titre de la section de sélection du thème sur le profil
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get profileAppearanceLabel;

  /// Libellé de l'entrée menant à l'historique de partie
  ///
  /// In fr, this message translates to:
  /// **'Activité'**
  String get profileActivityTitle;

  /// Titre de la page de configuration de partie
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle partie'**
  String get gameLobbyTitle;

  /// Mode solo contre l'IA
  ///
  /// In fr, this message translates to:
  /// **'Solo'**
  String get gameLobbyModeSolo;

  /// Description courte du mode solo
  ///
  /// In fr, this message translates to:
  /// **'Joue contre l\'IA'**
  String get gameLobbyModeSoloDescription;

  /// Mode multijoueur en ligne
  ///
  /// In fr, this message translates to:
  /// **'En ligne'**
  String get gameLobbyModeOnline;

  /// Description courte du mode en ligne
  ///
  /// In fr, this message translates to:
  /// **'Joue contre un ami'**
  String get gameLobbyModeOnlineDescription;

  /// Titre de la section de sélection du niveau de l'IA
  ///
  /// In fr, this message translates to:
  /// **'Niveau de l\'IA'**
  String get gameLobbyAiSection;

  /// Bouton pour démarrer la partie après la configuration
  ///
  /// In fr, this message translates to:
  /// **'Lancer la partie'**
  String get gameLobbyStartCta;

  /// Badge affiché sur les fonctionnalités non encore disponibles
  ///
  /// In fr, this message translates to:
  /// **'Bientôt'**
  String get gameLobbyComingSoon;

  /// Titre de la section invitation dans le mode en ligne
  ///
  /// In fr, this message translates to:
  /// **'Inviter un ami'**
  String get gameLobbyInviteTitle;

  /// Description de la fonctionnalité d'invitation par lien
  ///
  /// In fr, this message translates to:
  /// **'Partage un lien pour jouer ensemble'**
  String get gameLobbyInviteSubtitle;

  /// Titre de la section amis connectés dans le mode en ligne
  ///
  /// In fr, this message translates to:
  /// **'Amis en ligne'**
  String get gameLobbyFriendsTitle;

  /// Message affiché quand aucun ami n'est en ligne
  ///
  /// In fr, this message translates to:
  /// **'Aucun ami en ligne pour l\'instant'**
  String get gameLobbyFriendsEmpty;

  /// Description du niveau facile
  ///
  /// In fr, this message translates to:
  /// **'Parfait pour débuter'**
  String get gameDifficultyEasyDescription;

  /// Description du niveau moyen
  ///
  /// In fr, this message translates to:
  /// **'Un vrai défi'**
  String get gameDifficultyMediumDescription;

  /// Description du niveau difficile
  ///
  /// In fr, this message translates to:
  /// **'Pour les maîtres'**
  String get gameDifficultyHardDescription;

  /// Titre de la section de sélection du bot adversaire
  ///
  /// In fr, this message translates to:
  /// **'Choisis ton adversaire'**
  String get gameLobbySelectBot;

  /// Bouton de confirmation du niveau de difficulté
  ///
  /// In fr, this message translates to:
  /// **'Appliquer'**
  String get gameDifficultyApply;

  /// Libellé court du bouton d'annulation du dernier coup dans la barre d'actions
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get gameActionUndo;

  /// Libellé court du bouton de nouvelle partie dans la barre d'actions
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle'**
  String get gameActionNew;

  /// Libellé court du bouton d'options dans la barre d'actions
  ///
  /// In fr, this message translates to:
  /// **'Options'**
  String get gameActionOptions;

  /// Titre du dialog de proposition de nul
  ///
  /// In fr, this message translates to:
  /// **'Nul possible'**
  String get gameDrawClaimTitle;

  /// Message quand le nul est proposé par répétition de coup
  ///
  /// In fr, this message translates to:
  /// **'Le même coup a été joué 3 fois. Voulez-vous accepter le nul ?'**
  String get gameDrawClaimRepetitionMessage;

  /// Message quand le nul est proposé par absence de capture
  ///
  /// In fr, this message translates to:
  /// **'Aucune capture depuis {count} coups. Voulez-vous accepter le nul ?'**
  String gameDrawClaimNoCaptureMessage(int count);

  /// CTA pour accepter la proposition de nul
  ///
  /// In fr, this message translates to:
  /// **'Accepter le nul'**
  String get gameDrawClaimAccept;

  /// CTA pour refuser la proposition de nul et continuer à jouer
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get gameDrawClaimDecline;

  /// Titre de la section des options visuelles du plateau
  ///
  /// In fr, this message translates to:
  /// **'Affichage'**
  String get gameOptionsVisualSection;

  /// Toggle pour afficher / masquer les coups légaux sur le plateau
  ///
  /// In fr, this message translates to:
  /// **'Coups possibles'**
  String get gameOptionsMoveHints;

  /// Toggle pour afficher / masquer le surlignage du dernier coup de l'IA
  ///
  /// In fr, this message translates to:
  /// **'Dernier coup de l\'IA'**
  String get gameOptionsLastAiMove;

  /// Libellé de la carte de mode multijoueur local
  ///
  /// In fr, this message translates to:
  /// **'2 Joueurs'**
  String get gameLobbyModeLocal2p;

  /// Description courte du mode 2 joueurs local
  ///
  /// In fr, this message translates to:
  /// **'Face-à-face sur le même appareil'**
  String get gameLobbyModeLocal2pDescription;

  /// Titre de la section de configuration du mode 2 joueurs
  ///
  /// In fr, this message translates to:
  /// **'Configuration'**
  String get gameLobbyLocal2pSettings;

  /// Toggle pour pivoter le plateau entre les tours
  ///
  /// In fr, this message translates to:
  /// **'Retourner le plateau'**
  String get gameLobbyLocal2pFlipBoard;

  /// Titre de la section de sélection de la durée de la minuterie
  ///
  /// In fr, this message translates to:
  /// **'Minuterie'**
  String get gameLobbyLocal2pTimer;

  /// Option de minuterie : aucune limite de temps
  ///
  /// In fr, this message translates to:
  /// **'Sans limite'**
  String get gameLobbyLocal2pTimerNone;

  /// Option de minuterie avec durée en minutes
  ///
  /// In fr, this message translates to:
  /// **'{minutes} min'**
  String gameLobbyLocal2pTimerMin(int minutes);
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
