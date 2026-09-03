import "package:flutter/widgets.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// Icônes MagiCarré — centralisation de toutes les icônes de l'application.
///
/// Un seul point de vérité : pour changer un icon set ou remplacer une
/// icône, on modifie une seule constante ici.
///
/// Convention de nommage : camelCase descriptif selon le rôle / contexte.
class AppIcons {
  AppIcons._();

  // ─── Bottom Navigation (App Shell) ────────
  static const IconData navHome = LucideIcons.house;
  static const IconData navLobby = LucideIcons.swords;
  static const IconData navLeaderboard = LucideIcons.trophy;
  static const IconData navProfile = LucideIcons.userRound;

  // ─── Authentification & Formulaires ───────
  static const IconData email = LucideIcons.mail;
  static const IconData mail = LucideIcons.mail;
  static const IconData newLock = LucideIcons.rotateCcwKey;
  static const IconData lock = LucideIcons.lockKeyhole;
  static const IconData lockKeyhole = LucideIcons.lockKeyhole;
  static const IconData eye = LucideIcons.eye;
  static const IconData eyeOff = LucideIcons.eyeOff;

  // ─── Actions générales ────────────────────
  static const IconData plus = LucideIcons.plus;
  static const IconData arrowLeft = LucideIcons.arrowLeft;
  static const IconData arrowLeft500 = LucideIcons.arrowLeft500;
  static const IconData arrowRight = LucideIcons.arrowRight;
  static const IconData arrowRightBold = LucideIcons.arrowRight600;
  static const IconData check = LucideIcons.check;
  static const IconData ellipsis = LucideIcons.ellipsis;
  static const IconData search = LucideIcons.search;
  static const IconData share = LucideIcons.share;
  static const IconData pencil = LucideIcons.pencil;
  static const IconData trash = LucideIcons.trash2;
  static const IconData close = LucideIcons.x;
  static const IconData x = LucideIcons.x;
  static const IconData refresh = LucideIcons.refreshCw;
  static const IconData alertCircle = LucideIcons.alertCircle;
  static const IconData user = LucideIcons.userRound;

  // ─── Scan & OCR ───────────────────────────
  static const IconData scan = LucideIcons.scanText;
  static const IconData scanText = LucideIcons.scanText;
  static const IconData copy = LucideIcons.copy;
  static const IconData share2 = LucideIcons.share2;

  // ─── Game ───────────────────────────
  static const IconData play = LucideIcons.gamepad2;

  // ─── Contextes OCR / Documents ────────────
  static const IconData contextStudent = LucideIcons.graduationCap;
  static const IconData contextEducator = LucideIcons.bookOpen;
  static const IconData contextProfessional = LucideIcons.briefcase;
  static const IconData contextMerchant = LucideIcons.receipt;
  static const IconData contextGeneric = LucideIcons.fileText;
  static const IconData graduationCap = LucideIcons.graduationCap;
  static const IconData briefcase = LucideIcons.briefcase;
  static const IconData receipt = LucideIcons.receipt;
  static const IconData fileText = LucideIcons.fileText;
  static const IconData document = LucideIcons.fileText;
  static const IconData download = LucideIcons.fileDown;

  // ─── Bible / verset ───────────────────────
  static const IconData bookOpen = LucideIcons.bookOpen;
  static const IconData hash = LucideIcons.hash;

  // ─── Barre d'outils éditeur (spec §9.3) ───
  static const IconData textBold = LucideIcons.bold;
  static const IconData textItalic = LucideIcons.italic;
  static const IconData listUnordered = LucideIcons.list;
  static const IconData quote = LucideIcons.quote;

  // ─── Navigation & Chevrons ────────────────
  static const IconData chevronDown = LucideIcons.chevronDown;
  static const IconData chevronRight = LucideIcons.chevronRight;
  static const IconData chevronLeft = LucideIcons.chevronLeft;
  static const IconData chevronUp = LucideIcons.chevronUp;

  // ─── Visibilité & Collections ─────────────
  static const IconData public = LucideIcons.globe;
  static const IconData private = LucideIcons.lockKeyhole;
  static const IconData globe = LucideIcons.globe;
  static const IconData users = LucideIcons.users;
  static const IconData folder = LucideIcons.folder;
  static const IconData userRound = LucideIcons.userRound;

  // ─── Réglages & Thème ─────────────────────
  static const IconData settings = LucideIcons.settings;
  static const IconData sun = LucideIcons.sun;
  static const IconData moon = LucideIcons.moon;
  static const IconData logout = LucideIcons.logOut;
  static const IconData monitor = LucideIcons.monitor;

  // ─── Profil ───────────────────────────────
  static const IconData camera = LucideIcons.camera;
  static const IconData history = LucideIcons.history;
  static const IconData edit = LucideIcons.penLine;

  // ─── Classement ───────────────────────────
  static const IconData crown = LucideIcons.crown;

  // ─── Jeu ──────────────────────────────────
  static const IconData bot = LucideIcons.bot;
  static const IconData link = LucideIcons.link;
  static const IconData difficultyEasy = LucideIcons.circle;
  static const IconData difficultyMedium = LucideIcons.circleDot;
  static const IconData difficultyHard = LucideIcons.flame;
  static const IconData undo = LucideIcons.undo2;
  static const IconData timer = LucideIcons.timer;
  static const IconData flipBoard = LucideIcons.rotateCcw;
  static const IconData bullet = LucideIcons.rocket;
  static const IconData zap = LucideIcons.zap;
  static const IconData trophy = LucideIcons.trophy;
  static const IconData equal = LucideIcons.equal;

  // ─── États & Erreurs ──────────────────────
  static const IconData offline = LucideIcons.wifiOff;
  static const IconData wifiOff = LucideIcons.wifiOff;
  static const IconData sync = LucideIcons.refreshCw;
  static const IconData info = LucideIcons.info500;
  static const IconData info500 = LucideIcons.info500;
  static const IconData alertTriangle = LucideIcons.triangleAlert;
  static const IconData serverCrash = LucideIcons.serverCrash;
}
