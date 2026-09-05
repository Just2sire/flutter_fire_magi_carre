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
  String get commonOfflineBanner =>
      'Hors-ligne — affichage des données en cache';

  @override
  String get commonOr => 'Ou';

  @override
  String get authOrContinueWith => 'Ou continuer avec';

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
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'ton@email.com';

  @override
  String get authPasswordLabel => 'Mot de passe';

  @override
  String authPasswordHint(int length) {
    return 'Au moins $length caractères';
  }

  @override
  String get authConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get authUsernameLabel => 'Nom d\'utilisateur';

  @override
  String get authForgotPasswordLink => 'Mot de passe oublié ?';

  @override
  String get authAlreadyHaveAccount => 'Déjà un compte ?';

  @override
  String get authNoAccount => 'Pas de compte ?';

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
  String get authOAuthLoading => 'Connexion en cours…';

  @override
  String get authOAuthCancelled => 'Connexion annulée.';

  @override
  String authOAuthFailed(String provider) {
    return 'Échec de la connexion $provider. Réessaie.';
  }

  @override
  String authOAuthSuccess(String provider) {
    return 'Connexion avec $provider réussie !';
  }

  @override
  String get authOAuthSuccessGoogle => 'Connexion avec Google réussie !';

  @override
  String get authOAuthSuccessGithub => 'Connexion avec GitHub réussie !';

  @override
  String get authOAuthErrorGoogle =>
      'Échec de la connexion avec Google. Réessaie.';

  @override
  String get authOAuthErrorGithub =>
      'Échec de la connexion avec GitHub. Réessaie.';

  @override
  String get authOAuthCancelledGoogle => 'Connexion Google annulée.';

  @override
  String get authOAuthCancelledGithub => 'Connexion GitHub annulée.';

  @override
  String get authContinue => 'Continuer';

  @override
  String get authCompleteProfileTitle => 'Finalise ton profil';

  @override
  String get authCompleteProfileSubtitle =>
      'Choisis un nom d\'utilisateur pour apparaître dans le jeu.';

  @override
  String get authCompleteProfileButton => 'Terminer';

  @override
  String get authUsernameHint => 'Ex : MagiMaster, Player_123456';

  @override
  String get authUsernameHelper => 'Laisse vide pour générer automatiquement.';

  @override
  String get authShowPassword => 'Afficher le mot de passe';

  @override
  String get authHidePassword => 'Masquer le mot de passe';

  @override
  String get authBackToLogin => 'Retour à la connexion';

  @override
  String get authCheckEmailTitle => 'Vérifie tes e-mails';

  @override
  String get authCheckEmailSubtitle =>
      'Si un compte existe, tu recevras un lien de réinitialisation.';

  @override
  String get authForgotPasswordSuccess =>
      'Lien envoyé ! Vérifie ta messagerie.';

  @override
  String get authResetPasswordSubtitle =>
      'Choisis un nouveau mot de passe sécurisé.';

  @override
  String get authNewPasswordLabel => 'Nouveau mot de passe';

  @override
  String get authNewPasswordHint =>
      'Au moins 8 caractères, 1 majuscule, 1 chiffre';

  @override
  String get authConfirmNewPasswordLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get authResetSuccessTitle => 'Mot de passe mis à jour !';

  @override
  String get authResetSuccessMessage =>
      'Tu peux maintenant te connecter avec ton nouveau mot de passe.';

  @override
  String get authInvalidResetLink =>
      'Lien invalide ou expiré. Demande un nouveau lien.';

  @override
  String get authPasswordUpdateSuccess => 'Mot de passe modifié avec succès.';

  @override
  String get authVerifyEmailTitle => 'Vérifie ta boîte mail';

  @override
  String authVerifyEmailSubtitle(String email) {
    return 'Un lien de vérification a été envoyé à $email.';
  }

  @override
  String get authResendEmail => 'Renvoyer l\'e-mail';

  @override
  String authSignupSuccess(String username) {
    return 'Compte créé ! Bienvenue $username !';
  }

  @override
  String get authLogout => 'Déconnexion';

  @override
  String get authLogoutButton => 'Se déconnecter';

  @override
  String get authLogoutConfirmTitle => 'Se déconnecter ?';

  @override
  String get authLogoutConfirmMessage =>
      'Es-tu sûr de vouloir te déconnecter ?';

  @override
  String get authLogoutSuccess => 'Déconnecté avec succès.';

  @override
  String authLoginSuccess(String username) {
    return 'Connexion réussie ! Ravie de te revoir, $username !';
  }

  @override
  String get authLoginError =>
      'Échec de la connexion. Vérifie tes identifiants.';

  @override
  String get authSignupError => 'Échec de l\'inscription. Réessaie.';

  @override
  String get authLogoutError => 'Échec de la déconnexion. Réessaie.';

  @override
  String get authResendSuccess => 'E-mail renvoyé !';

  @override
  String get authResendError => 'Impossible d\'envoyer l\'e-mail. Réessaie.';

  @override
  String authCompleteProfileSuccess(String username) {
    return 'Profil complété ! Bienvenue $username !';
  }

  @override
  String get authVerifySuccessTitle => 'Adresse vérifiée !';

  @override
  String get authVerifySuccessMessage =>
      'Ton adresse e-mail a été vérifiée avec succès.';

  @override
  String get authGenericSuccess => 'Opération réussie.';

  @override
  String get authGenericError => 'Une erreur est survenue. Réessaie.';

  @override
  String get authErrorInvalidCredentials =>
      'Identifiants invalides. Vérifie ton e-mail et ton mot de passe.';

  @override
  String get authErrorSessionExpired =>
      'Session expirée. Veuillez vous reconnecter.';

  @override
  String get authErrorUnauthorized => 'Accès non autorisé.';

  @override
  String get authErrorUserNotFound => 'Utilisateur introuvable.';

  @override
  String get authErrorOAuthCancelled => 'Connexion annulée.';

  @override
  String get authErrorGoogleCancelled => 'Connexion Google annulée.';

  @override
  String get authErrorUsernameTaken => 'Ce nom d\'utilisateur est déjà pris.';

  @override
  String get authErrorWeakPassword => 'Mot de passe trop faible.';

  @override
  String get authErrorTooManyRequests =>
      'Trop de tentatives. Réessaie dans quelques minutes.';

  @override
  String get authEmailAlreadyExists => 'Un compte existe déjà avec cet e-mail.';

  @override
  String get authTermsPrefix => 'En créant un compte, tu acceptes nos';

  @override
  String get authTermsLink => 'Conditions d\'utilisation';

  @override
  String get authTermsAnd => 'et notre';

  @override
  String get authPrivacyLink => 'Politique de confidentialité';

  @override
  String get authTermsSuffix => '.';

  @override
  String get authSkipTitle => 'Continuer sans compte ?';

  @override
  String get authSkipMessage =>
      'Sans compte, tu ne pourras pas jouer en ligne, sauvegarder ta progression ni apparaître au classement. Tu pourras toujours jouer hors ligne.';

  @override
  String get authSkipConfirm => 'Continuer en invité';

  @override
  String get authSkipCancel => 'Créer un compte';

  @override
  String get authGuestWarning => 'Mode invité — progression non sauvegardée';

  @override
  String get authGateTitle => 'Connecte-toi pour continuer';

  @override
  String get authGateSubtitle =>
      'Sauvegarde ta progression, joue en ligne et grimpe au classement.';

  @override
  String get authGateLoginWithEmail => 'Se connecter par e-mail';

  @override
  String get authGateCreateAccount => 'Créer un compte';

  @override
  String get authGateContinueAsGuest => 'Continuer en invité';

  @override
  String get authOnlineRequiresAccount =>
      'Un compte est requis pour jouer en ligne.';

  @override
  String get validationRequired => 'Ce champ est obligatoire.';

  @override
  String get validationInvalidEmail => 'Adresse e-mail invalide.';

  @override
  String get validationEmailIncorrect => 'Adresse e-mail incorrecte.';

  @override
  String get validationPasswordTooShort =>
      'Le mot de passe doit contenir au moins 8 caractères.';

  @override
  String get validationPasswordsDoNotMatch =>
      'Les mots de passe ne correspondent pas.';

  @override
  String validationUsernameTooShort(int minLength) {
    return 'Au moins $minLength caractères.';
  }

  @override
  String validationUsernameTooLong(int maxLength) {
    return '$maxLength caractères maximum.';
  }

  @override
  String get validationUsernameInvalid => 'Lettres, chiffres et _ uniquement.';

  @override
  String get routerErrorTitle => 'Cet écran n\'existe pas encore.';

  @override
  String get routerErrorSubtitle =>
      'Reviens plus tard, ou reprends depuis l\'accueil.';

  @override
  String routerSoon(String title) {
    return '$title — bientôt.';
  }

  @override
  String get errorNetwork => 'Erreur réseau. Vérifie ta connexion internet.';

  @override
  String get errorServer => 'Erreur serveur. Réessaie plus tard.';

  @override
  String get errorValidation => 'Données invalides. Vérifie les champs.';

  @override
  String get errorUnknown => 'Une erreur inconnue est survenue.';

  @override
  String get navHome => 'Accueil';

  @override
  String get navLobby => 'Lobby';

  @override
  String get navLeaderboard => 'Classement';

  @override
  String get navProfile => 'Profil';

  @override
  String get leaderboardTitle => 'Classement';

  @override
  String get leaderboardSubtitle => 'Les meilleurs joueurs de MagiCarré';

  @override
  String get leaderboardTop50 => 'Top 50';

  @override
  String get leaderboardMyRank => 'Ton rang';

  @override
  String get leaderboardRank => 'Rang';

  @override
  String get leaderboardPlayer => 'Joueur';

  @override
  String get leaderboardRating => 'Score';

  @override
  String leaderboardRankLabel(int rank) {
    return '#$rank';
  }

  @override
  String leaderboardRatingLabel(int rating) {
    return '$rating pts';
  }

  @override
  String get leaderboardYou => 'Toi';

  @override
  String get leaderboardEmptyTitle => 'Aucun classement disponible';

  @override
  String get leaderboardEmptySubtitle =>
      'Sois le premier à grimper au sommet !';

  @override
  String get leaderboardErrorTitle => 'Erreur de chargement';

  @override
  String get leaderboardErrorMessage =>
      'Impossible de charger le classement. Réessaie.';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsLogout => 'Se déconnecter';

  @override
  String get settingsLogoutConfirmTitle => 'Se déconnecter ?';

  @override
  String get settingsLogoutConfirmMessage =>
      'Tu devras te reconnecter pour accéder à ton compte.';

  @override
  String get settingsAccountSection => 'Compte';

  @override
  String get settingsGameSection => 'Jeu';

  @override
  String get settingsBoardTheme => 'Thème du plateau';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEditTitle => 'Modifier le profil';

  @override
  String get profileEditUsernameLabel => 'Nom d\'utilisateur';

  @override
  String get profileEditBioLabel => 'Bio';

  @override
  String get profileUpdateSuccess => 'Profil mis à jour avec succès.';

  @override
  String get profileAvatarChangeCta => 'Changer la photo';

  @override
  String get profileChangePasswordCta => 'Modifier le mot de passe';

  @override
  String get profileRatingLabel => 'Classement';

  @override
  String get profileFriendsLabel => 'Amis';

  @override
  String get profileStatsSection => 'Statistiques';

  @override
  String get profileWinsLabel => 'Victoires';

  @override
  String get profileLossesLabel => 'Défaites';

  @override
  String get profileDrawsLabel => 'Nuls';

  @override
  String profileSetupTitle(String username) {
    return 'Bienvenue, $username !';
  }

  @override
  String get profileSetupSubtitle =>
      'Dites-nous quelques mots sur vous pour personnaliser votre profil.';

  @override
  String get profileSetupBioHint => 'Parlez de vous... (optionnel)';

  @override
  String get profileSetupCta => 'Commencer à jouer';

  @override
  String get profileGuestMessage => 'Connecte-toi pour accéder à ton profil.';

  @override
  String get profileGuestCta => 'Se connecter';

  @override
  String get gameTitle => 'Duel local';

  @override
  String get gameAiThinking => 'L\'IA réfléchit…';

  @override
  String get gameDifficultyTitle => 'Difficulté de l\'IA';

  @override
  String get gameDifficultyEasy => 'Débutant';

  @override
  String get gameDifficultyMedium => 'Intermédiaire';

  @override
  String get gameDifficultyHard => 'Expert';

  @override
  String get gameOverWhiteWinsTitle => 'Victoire !';

  @override
  String get gameOverWhiteWinsMessage => 'Tu as gagné la partie.';

  @override
  String get gameOverBlackWinsTitle => 'Défaite';

  @override
  String get gameOverBlackWinsMessage => 'L\'IA a gagné cette partie.';

  @override
  String get gameOverDrawTitle => 'Match nul';

  @override
  String get gameOverDrawMessage => 'Aucun joueur n\'a pu l\'emporter.';

  @override
  String get gameNewGameCta => 'Nouvelle partie';

  @override
  String get gameQuitCta => 'Quitter';

  @override
  String get gamePlayerBlack => 'Noirs';

  @override
  String get gamePlayerWhite => 'Blancs';

  @override
  String gamePiecesCaptured(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pions capturés',
      one: '1 pion capturé',
      zero: '0 pion capturé',
    );
    return '$_temp0';
  }

  @override
  String get gameUndoCta => 'Annuler le dernier coup';

  @override
  String get gameRestartCta => 'Recommencer la partie';

  @override
  String get profileEditCta => 'Modifier';

  @override
  String get profileAppearanceLabel => 'Apparence';

  @override
  String get profileActivityTitle => 'Activité';

  @override
  String get profileHistoryEmpty => 'Pas encore de parties jouées.';

  @override
  String get profileHistoryOpponentAiEasy => 'IA · Débutant';

  @override
  String get profileHistoryOpponentAiMedium => 'IA · Intermédiaire';

  @override
  String get profileHistoryOpponentAiHard => 'IA · Expert';

  @override
  String get profileHistoryOpponentHuman => '2 Joueurs';

  @override
  String get profileHistoryOpponentOnline => 'En ligne';

  @override
  String get gameLobbyTitle => 'Nouvelle partie';

  @override
  String get gameLobbyModeSolo => 'Solo';

  @override
  String get gameLobbyModeSoloDescription => 'Joue contre l\'IA';

  @override
  String get gameLobbyModeOnline => 'En ligne';

  @override
  String get gameLobbyModeOnlineDescription => 'Joue contre un ami';

  @override
  String get gameLobbyAiSection => 'Niveau de l\'IA';

  @override
  String get gameLobbyStartCta => 'Lancer la partie';

  @override
  String get gameDifficultyEasyDescription => 'Parfait pour débuter';

  @override
  String get gameDifficultyMediumDescription => 'Un vrai défi';

  @override
  String get gameDifficultyHardDescription => 'Pour les maîtres';

  @override
  String get gameLobbySelectBot => 'Choisis ton adversaire';

  @override
  String get gameDifficultyApply => 'Appliquer';

  @override
  String get gameActionUndo => 'Annuler';

  @override
  String get gameActionNew => 'Nouvelle';

  @override
  String get gameActionOptions => 'Options';

  @override
  String get gameDrawClaimTitle => 'Nul possible';

  @override
  String get gameDrawClaimRepetitionMessage =>
      'Le même coup a été joué 3 fois. Voulez-vous accepter le nul ?';

  @override
  String gameDrawClaimNoCaptureMessage(int count) {
    return 'Aucune capture depuis $count coups. Voulez-vous accepter le nul ?';
  }

  @override
  String get gameDrawClaimAccept => 'Accepter le nul';

  @override
  String get gameDrawClaimDecline => 'Continuer';

  @override
  String get gameOptionsVisualSection => 'Affichage';

  @override
  String get gameOptionsMoveHints => 'Coups possibles';

  @override
  String get gameOptionsLastAiMove => 'Dernier coup de l\'IA';

  @override
  String get gameLobbyModeLocal2p => '2 Joueurs';

  @override
  String get gameLobbyModeLocal2pDescription =>
      'Face-à-face sur le même appareil';

  @override
  String get gameLobbyLocal2pSettings => 'Configuration';

  @override
  String get gameLobbyLocal2pFlipBoard => 'Retourner le plateau';

  @override
  String get gameLobbyLocal2pTimer => 'Minuterie';

  @override
  String get gameLobbyLocal2pTimerNone => 'Sans limite';

  @override
  String gameLobbyLocal2pTimerMin(int minutes) {
    return '$minutes min';
  }

  @override
  String homeGreeting(String username) {
    return 'Hey, $username !';
  }

  @override
  String get homeGreetingSubtitle => 'Prêt à jouer ?';

  @override
  String get homeGuestUsername => 'Invité';

  @override
  String get homeStatStreak => 'Série';

  @override
  String get homeStatRating => 'ELO';

  @override
  String get homeStatRank => 'Rang';

  @override
  String get homeStatPlaceholder => '—';

  @override
  String get homePlayNowTitle => 'Nouvelle partie';

  @override
  String get homePlayNowSubtitle => 'Défie l\'IA ou un ami';

  @override
  String get homePlayNowCta => 'Jouer';

  @override
  String get homeQuickModesTitle => 'Modes rapides';

  @override
  String get homeModeBot => 'vs Bot';

  @override
  String get homeMode2p => '2 Joueurs';

  @override
  String get homeModeOnline => 'En ligne';


  @override
  String get homeLeaderboardTitle => 'Top classement';

  @override
  String get homeLeaderboardSeeAll => 'Voir tout';

  @override
  String get homeModeRules => 'Règles';

  @override
  String get learnTitle => 'Règles du jeu';

  @override
  String get learnGoalTitle => 'But du jeu';

  @override
  String get learnGoalBody =>
      'Capturez toutes les pièces adverses, ou bloquez-les de sorte qu\'elles ne puissent plus bouger. Le dernier joueur à pouvoir se déplacer remporte la partie.';

  @override
  String get learnMoveTitle => 'Déplacement';

  @override
  String get learnMoveBody =>
      'Vos pièces se déplacent d\'une intersection à la suivante, le long des lignes du plateau. Sur les intersections à 8 directions (rangée + colonne paires), le mouvement diagonal est aussi possible.';

  @override
  String get learnCaptureTitle => 'Capture';

  @override
  String get learnCaptureBody =>
      'Pour capturer un pion adverse, sautez par-dessus lui en ligne droite. La case d\'atterrissage doit être libre. La pièce capturée est retirée du plateau.';

  @override
  String get learnChainTitle => 'Promotion';

  @override
  String get learnChainBody =>
      'Quand votre pièce atteint la rangée adverse et que vous avez une pièce capturée en réserve, vous pouvez replacer une pièce supplémentaire sur une case vide de votre propre rangée de départ. Les cases dorées indiquent les emplacements disponibles.';

  @override
  String get learnPromotionTitle => 'Victoire';

  @override
  String get learnPromotionBody =>
      'Capturez toutes les pièces adverses pour remporter la partie. Vous gagnez également si votre adversaire ne peut plus effectuer aucun déplacement.';

  @override
  String get onlineLobbyTitle => 'Partie en ligne';

  @override
  String get onlineLobbyQuickMatchTitle => 'Partie rapide';

  @override
  String get onlineLobbyQuickMatchCta => 'Chercher un adversaire';

  @override
  String get onlineLobbySearching => 'Recherche d\'un adversaire…';

  @override
  String get onlineLobbyCancelSearch => 'Annuler';

  @override
  String get onlineLobbyInviteTitle => 'Inviter un ami';

  @override
  String get onlineLobbyCreateInviteCta => 'Créer une invitation';

  @override
  String get onlineLobbyJoinCodeLabel => 'Code d\'invitation';

  @override
  String get onlineLobbyJoinCta => 'Rejoindre';

  @override
  String get onlineLobbyInvalidCode => 'Code invalide ou expiré';

  @override
  String get onlineLobbyResumeTitle => 'Parties en cours';

  @override
  String get onlineLobbyResumeMatch => 'Partie en ligne';

  @override
  String get onlineLobbyResumeSubtitleWhite => 'Vous jouez les blancs';

  @override
  String get onlineLobbyResumeSubtitleBlack => 'Vous jouez les noirs';

  @override
  String get onlineInviteTitle => 'Créer une invitation';

  @override
  String get onlineInviteTimerTitle => 'Cadence';

  @override
  String get onlineInviteRatedToggle => 'Partie classée';

  @override
  String get onlineInviteRatedSubtitle => 'Affecte votre classement ELO';

  @override
  String get onlineInviteGenerateCta => 'Générer le code';

  @override
  String get onlineInviteShareTitle => 'Partage ce code';

  @override
  String get onlineInviteCopyCta => 'Copier';

  @override
  String get onlineInviteCopied => 'Code copié !';

  @override
  String get onlineInviteWaiting => 'En attente d\'un adversaire…';

  @override
  String get onlineJoinTitle => 'Rejoindre une partie';

  @override
  String get onlineJoinCodeHint => 'Entrez le code à 6 caractères';

  @override
  String get onlineJoinCta => 'Rejoindre';

  @override
  String get onlineGameOpponent => 'Adversaire';

  @override
  String get onlineGameResignCta => 'Abandonner';

  @override
  String get onlineGameResignConfirmTitle => 'Abandonner la partie ?';

  @override
  String get onlineGameResignConfirmMessage => 'Vous perdrez cette partie.';

  @override
  String get onlineGameBackToLobbyCta => 'Retour au lobby';
}
