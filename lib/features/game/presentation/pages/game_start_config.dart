import "package:flutter/material.dart";

/// Données de départ d'une partie locale — transmises via GoRouter `extra`
/// depuis le lobby vers GamePage.
class GameStartConfig {
  const GameStartConfig({
    required this.level,
    required this.botName,
    required this.botColor,
    this.isLocalMultiplayer = false,
    this.timerDurationSeconds = 0,
    this.incrementSeconds = 0,
    this.flipBoard = false,
  });

  /// Niveau IA (1–10), passé à GameNotifier.requestAiMove.
  /// Ignoré quand [isLocalMultiplayer] est vrai.
  final int level;

  /// Nom affiché du bot (ex. "Abéna").
  /// Ignoré quand [isLocalMultiplayer] est vrai.
  final String botName;

  /// Couleur d'accentuation du bot pour l'avatar en jeu.
  /// Ignorée quand [isLocalMultiplayer] est vrai.
  final Color botColor;

  /// `true` = partie locale à deux joueurs humains sur le même appareil.
  /// `false` = partie solo contre l'IA.
  final bool isLocalMultiplayer;

  /// Durée initiale de la minuterie par joueur, en secondes.
  /// `0` = pas de minuterie.
  final int timerDurationSeconds;

  /// Secondes ajoutées au compteur du joueur après chaque coup joué.
  /// `0` = pas d'incrément (cadence simple).
  final int incrementSeconds;

  /// `true` = le plateau pivote de 180° entre les tours en mode 2 joueurs.
  final bool flipBoard;
}
