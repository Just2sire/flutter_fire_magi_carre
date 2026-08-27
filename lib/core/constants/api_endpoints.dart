class ApiEndpoints {
  ApiEndpoints._();

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String requestOtp = "/auth/login/otp/request";
  static const String verifyOtp = "/auth/login/otp/verify";
  static const String logout = "/auth/logout";
  static const String me = "/auth/me";

  // ─── Profile ──────────────────────────────────────────────────────────────
  static const String profile = "/profile";
  static const String updateSituation = "/profile/situation";

  // ─── Home ─────────────────────────────────────────────────────────────────
  static const String home = "/home";

  // ─── Onboarding ───────────────────────────────────────────────────────────
  static const String onboarding = "/onboarding";

  // ─── Devices ──────────────────────────────────────────────────────────────
  static const String registerDevice = "/devices/register";
  static const String unregisterDevice = "/devices/unregister";

  // ─── Sync ─────────────────────────────────────────────────────────────────
  static const String syncManifest = "/sync/manifest";
  static const String syncDelta = "/sync/delta";
  static const String syncBatch = "/sync/batch";
  static const String syncPush = "/sync/push";

  // ─── Search & Compare ─────────────────────────────────────────────────────
  static const String search = "/search";
  static const String compare = "/compare";

  // ─── Notifications ────────────────────────────────────────────────────────
  static const String notifications = "/notifications";
  static const String notificationsReadAll = "/notifications/read-all";
  static const String notificationPreferences = "/notifications/preferences";
  static String notification(String id) => "/notifications/$id";
  static String notificationMarkRead(String id) => "/notifications/$id/read";

  // ─── Favorites ────────────────────────────────────────────────────────────
  static const String favorites = "/favorites";
  static String favorite(String id) => "/favorites/$id";
}
