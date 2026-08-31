# TODO

- [ ] **Gestion des environnements avec `--dart-define-from-file`**
  - Créer les fichiers : `config/dev.json` et `config/prod.json`.
  - Exemple de commande : `flutter run --dart-define-from-file=config/dev.json`
  - Accès dans le code : `const String.fromEnvironment('MY_API_KEY')`
  
- [ ] **Obfuscation du code pour la production**
  - Commande pour Android : `flutter build apk --obfuscate --split-debug-info=build/app/outputs/symbols`
  - Commande pour iOS : `flutter build ipa --obfuscate --split-debug-info=build/app/outputs/symbols`
