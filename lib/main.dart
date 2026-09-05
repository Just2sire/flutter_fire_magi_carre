import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_timezone/flutter_timezone.dart";
import "package:go_router/go_router.dart" show GoRouterHelper;
import "package:shared_preferences/shared_preferences.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:timezone/data/latest_all.dart" as tz;
import "package:timezone/timezone.dart" as tz;

import "app.dart";
import "core/configs/index.dart";
import "core/routing/app_navigator_key.dart";
import "shared/data/services/local_cache_service.dart";
import "shared/data/services/notification_service.dart";
import "shared/presentation/providers/index.dart"
    show
        sharedPreferencesProvider,
        flutterLocalNotificationsPluginProvider,
        localCacheServiceProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de la configuration globale
  AppConfig.initialize(environment: Env.current);

  // Configure Logger
  AppLogger.configure(
    enabled: Env.enableLogging,
    showTimestamp: true,
    showEmoji: true,
    minLevel: Env.isDevelopment ? LogLevel.debug : LogLevel.warning,
    appName: Env.appName,
  );

  Log.i("Starting application in ${Env.current.name} mode...");

  try {
    await _bootstrap();
  } on Object catch (e, st) {
    // Filet de sécurité : si une étape d'init plante avant runApp(), l'app
    // restait bloquée indéfiniment sur l'écran noir/blanc natif — aucune
    // erreur visible, juste un ANR silencieux (vécu en prod sur un vrai
    // appareil). On préfère toujours afficher QUELQUE CHOSE, même une
    // erreur brute, plutôt que ne jamais appeler runApp().
    Log.e("Échec critique au démarrage", error: e, stackTrace: st);
    runApp(_BootstrapErrorApp(error: e));
  }
}

/// Toutes les étapes d'initialisation avant runApp(). Les étapes non
/// essentielles (dotenv, timezone, notifications) sont individuellement
/// résilientes — leur échec dégrade une fonctionnalité mais ne bloque
/// jamais le lancement de l'app.
Future<void> _bootstrap() async {
  // Repli de dev uniquement — les builds pilotés par
  // --dart-define-from-file (voir config/*.json) n'ont pas besoin de .env
  // et peuvent tourner sans qu'il soit présent.
  try {
    await dotenv.load();
    Log.i("dotenv loaded");
  } on Object catch (e) {
    Log.w("Pas de .env trouvé, on continue avec --dart-define uniquement : $e");
  }

  // SharedPreferences doit être initialisé avant runApp
  final prefs = await SharedPreferences.getInstance();

  // Cache local (Hive) — support du mode hors-ligne
  final cacheBox = await LocalCacheService.init();
  final localCacheService = LocalCacheService(cacheBox);

  // Timezone — requis pour zonedSchedule (notifications planifiées).
  // Non-bloquant : sans ça, les notifications programmées sont juste
  // désactivées, le reste de l'app tourne normalement.
  try {
    tz.initializeTimeZones();
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
    Log.d("Timezone local: ${timezoneInfo.identifier}");
  } on Object catch (e) {
    Log.w("Échec init timezone, notifications programmées désactivées : $e");
  }

  // Notifications — non-bloquant, même logique.
  FlutterLocalNotificationsPlugin? notificationPlugin;
  try {
    notificationPlugin = await NotificationService.createAndInit(
      onTap: _onNotificationTap,
    );
    Log.i("NotificationService initialisé");
  } on Object catch (e) {
    Log.w("Échec init notifications, fonctionnalité désactivée : $e");
  }

  // Supabase — ici en revanche, l'app entière en dépend (auth, données) :
  // une erreur pendant Supabase.initialize doit rester fatale et remonter
  // au catch de main() plutôt que d'être avalée silencieusement.
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    publishableKey: AppConfig.supabaseAnonKey,
  );
  Log.i(
    "Supabase initialisé : ${Supabase.instance.client.auth.currentSession}",
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        flutterLocalNotificationsPluginProvider.overrideWithValue(
          notificationPlugin ?? FlutterLocalNotificationsPlugin(),
        ),
        localCacheServiceProvider.overrideWithValue(localCacheService),
      ],
      child: const MainApp(),
    ),
  );
}

/// Écran de secours affiché si l'initialisation plante avant runApp() —
/// toujours préférable à un écran noir/blanc figé sans aucun retour.
class _BootstrapErrorApp extends StatelessWidget {
  const _BootstrapErrorApp({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF1C1B1F),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                const Text(
                  "Échec du démarrage",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "$error",
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Tap depuis premier plan ou arrière-plan (app vivante)
void _onNotificationTap(NotificationResponse response) {
  final rawPayload = response.payload;
  if (rawPayload == null || rawPayload.isEmpty) return;

  try {
    final payload = NotificationPayload.fromJsonString(rawPayload);
    Log.i("Notification tappée, route: ${payload.route}");
    AppNavigatorKey.instance.currentState?.context.go(payload.route);
  } catch (e, st) {
    Log.e("Échec parsing payload notification", error: e, stackTrace: st);
  }
}
