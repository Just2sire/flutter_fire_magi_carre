# TODO

- [x] **Gestion des environnements avec `--dart-define-from-file`**
  - `config/dev.json` et `config/prod.json` (gitignorés, contiennent les vraies
    valeurs) + `config/dev.json.example` et `config/prod.json.example`
    (commités, templates).
  - `flutter run --dart-define-from-file=config/dev.json`
  - Accès dans le code : `AppConfig.supabaseUrl` etc.
    (`lib/core/configs/app_config.dart`), qui lit `String.fromEnvironment`
    en priorité et retombe sur `.env` (flutter_dotenv) si absent — les deux
    mécanismes cohabitent volontairement.
  - `Env.current` (dev/staging/prod) est maintenant piloté par la clé `ENV`
    du fichier de config, plus figé sur `development`.
  - Voir [README — Builds & environnements](README.md#builds--environnements).

- [x] **Obfuscation du code pour la production**
  - `scripts/build.ps1 prod` / `scripts/build.sh prod` — obfusqué, symboles
    sauvegardés dans `build/app/outputs/symbols/`, split par ABI.
  - Commande Android brute : `flutter build apk --obfuscate --split-debug-info=build/app/outputs/symbols --split-per-abi --dart-define-from-file=config/prod.json`
  - Commande iOS (projet iOS pas encore initialisé — `flutter create --platforms=ios .` d'abord) : `flutter build ipa --obfuscate --split-debug-info=build/app/outputs/symbols --dart-define-from-file=config/prod.json`
