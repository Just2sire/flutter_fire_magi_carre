import "package:flutter/services.dart";
import "package:flutter/widgets.dart";

/// Boîte à outils globale pour MagiCarré.
///
/// Contient des méthodes statiques utilitaires pour le formatage, la validation
/// et les interactions système courantes.
class AppUtils {
  const AppUtils._();

  // ─────────────────────────────────────────────
  // FORMATTAGE
  // ─────────────────────────────────────────────

  /// Formate une date de manière humaine (Aujourd'hui, Hier, etc.).
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0 && now.day == date.day) {
      return "Aujourd'hui";
    }
    if (diff.inDays <= 1 && now.day != date.day) {
      return "Hier";
    }
    if (diff.inDays < 7) {
      return "Il y a ${diff.inDays} jours";
    }

    final day = date.day.toString().padLeft(2, "0");
    final month = date.month.toString().padLeft(2, "0");
    return "$day/$month/${date.year}";
  }

  /// Convertit une taille en octets en une chaîne lisible (Ko, Mo, Go).
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 o";
    const suffixes = ["o", "Ko", "Mo", "Go", "To"];
    var i = 0;
    var size = bytes.toDouble();
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return "${size.toStringAsFixed(1)} ${suffixes[i]}";
  }

  // ─────────────────────────────────────────────
  // STRINGS
  // ─────────────────────────────────────────────

  /// Met la première lettre en majuscule.
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }

  /// Tronque une chaîne avec des points de suspension
  /// si elle dépasse [maxLength].
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return "${text.substring(0, maxLength)}...";
  }

  /// Extrait les initiales d'un nom (ex: "Jean Dupont" -> "JD").
  static String getInitials(String name) {
    if (name.isEmpty) return "";
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.length > 1) {
      return "${parts[0][0]}${parts[parts.length - 1][0]}".toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  // ─────────────────────────────────────────────
  // VALIDATION
  // ─────────────────────────────────────────────

  /// Vérifie si le format de l'e-mail est valide.
  static bool isValidEmail(String email) {
    return email.contains("@");
    // return RegExp(
    //   r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    // ).hasMatch(email);
  }

  // ─────────────────────────────────────────────
  // SYSTÈME / UI
  // ─────────────────────────────────────────────

  /// Ferme le clavier logiciel.
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// Copie un texte dans le presse-papier.
  static Future<void> copyToClipboard(String text) async {
    if (text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
  }
}
