// Run from the project root:
//   dart run tool/generate_bot_avatars.dart
//
// Generates SVG assets for the 10 fixed bot characters using DiceBear bottts
// style. Output goes to assets/avatars/bots/. Re-run if bot seeds change.

import "dart:io";

import "package:dicebear_core/dicebear_core.dart";
import "package:dicebear_styles/bottts.dart";

const _bots = [
  ("Ama", "ama"),
  ("Kofi", "kofi"),
  ("Yaa", "yaa"),
  ("Kwamé", "kwame"),
  ("Abéna", "abena"),
  ("Kojo", "kojo"),
  ("Akua", "akua"),
  ("Efua", "efua"),
  ("Yaw", "yaw"),
  ("Nana", "nana"),
];

void main() {
  final style = Style.parse(bottts);
  final dir = Directory("assets/avatars/bots")..createSync(recursive: true);

  for (final (seed, filename) in _bots) {
    final avatar = Avatar(style, {"seed": seed, "size": 200});
    File("${dir.path}/$filename.svg").writeAsStringSync(avatar.svg);
    stdout.writeln("  ✓  $filename.svg  ($seed)");
  }

  stdout.writeln("\nDone — ${_bots.length} SVGs written to ${dir.path}");
}
