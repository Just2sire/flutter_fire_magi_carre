import "package:flutter/foundation.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "env.dart";

/// Main application configuration
class AppConfig {
  AppConfig._();

  static late final AppConfigData _instance;

  static AppConfigData get instance => _instance;

  // ─── Secrets ────────────────────────────────────────────────────────────
  //
  // Deux sources, dart-define prioritaire :
  // 1. `--dart-define-from-file=config/<env>.json` — valeurs compilées en
  //    dur dans le binaire, requis pour les builds obfusqués/CI/CD
  //    (voir config/dev.json.example, config/prod.json.example).
  // 2. `.env` (flutter_dotenv) — repli pratique pour `flutter run` sans
  //    flag pendant le développement local.
  //
  // `String.fromEnvironment` renvoie "" quand la clé n'a pas été fournie au
  // build, d'où le test `isNotEmpty` avant de retomber sur dotenv.

  // ignore: do_not_use_environment
  static const _dartDefineSupabaseUrl = String.fromEnvironment(
    "SUPABASE_URL",
  );
  // ignore: do_not_use_environment
  static const _dartDefineSupabaseAnonKey = String.fromEnvironment(
    "SUPABASE_ANON_KEY",
  );
  // ignore: do_not_use_environment
  static const _dartDefineGoogleWebClientId = String.fromEnvironment(
    "GOOGLE_WEB_CLIENT_ID",
  );
  // ignore: do_not_use_environment
  static const _dartDefineGoogleIosClientId = String.fromEnvironment(
    "GOOGLE_IOS_CLIENT_ID",
  );

  static String get supabaseUrl => _dartDefineSupabaseUrl.isNotEmpty
      ? _dartDefineSupabaseUrl
      : dotenv.env["SUPABASE_URL"]!;

  static String get supabaseAnonKey => _dartDefineSupabaseAnonKey.isNotEmpty
      ? _dartDefineSupabaseAnonKey
      : dotenv.env["SUPABASE_ANON_KEY"]!;

  /// Client OAuth Web — requis par Google Sign-In natif même sur Android
  /// (voir `serverClientId` dans `GoogleSignIn.initialize`).
  static String get googleWebClientId =>
      _dartDefineGoogleWebClientId.isNotEmpty
      ? _dartDefineGoogleWebClientId
      : dotenv.env["GOOGLE_WEB_CLIENT_ID"] ?? "";

  /// Client OAuth iOS — optionnel, uniquement nécessaire pour builder iOS.
  static String get googleIosClientId =>
      _dartDefineGoogleIosClientId.isNotEmpty
      ? _dartDefineGoogleIosClientId
      : dotenv.env["GOOGLE_IOS_CLIENT_ID"] ?? "";

  static void initialize({
    required Environment environment,
    String? apiKey,
    Map<String, dynamic>? customConfig,
  }) {
    Env.current = environment;

    _instance = AppConfigData(
      environment: environment,
      apiKey: apiKey,
      customConfig: customConfig ?? {},
    );
  }
}

class AppConfigData {
  const AppConfigData({
    required this.environment,
    this.apiKey,
    this.customConfig = const {},
  });

  final Environment environment;
  final String? apiKey;
  final Map<String, dynamic> customConfig;

  // Getters
  bool get isDebug => kDebugMode;
  bool get isRelease => kReleaseMode;
  bool get isProfile => kProfileMode;

  String get apiBaseUrl => Env.apiBaseUrl;
  String get appName => Env.appName;

  // Feature flags
  bool get enableDebugTools => environment == Environment.development;
  bool get enablePerformanceMonitoring =>
      environment != Environment.development;

  // Custom config getters
  String get fontFamily => "Syne";
  int get maxRetries => getConfig<int>("maxRetries") ?? 0;

  T? getConfig<T>(String key, [T? defaultValue]) {
    return customConfig[key] as T? ?? defaultValue;
  }

  @override
  String toString() {
    return "AppConfig(env: $environment, apiUrl: $apiBaseUrl)";
  }
}
