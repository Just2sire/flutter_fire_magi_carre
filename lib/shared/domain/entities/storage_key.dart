enum StorageKey {
  // ── Sensible → flutter_secure_storage ───────────
  accessToken(secure: true),
  refreshToken(secure: true),
  biometricEnabled(secure: true),

  // ── Non sensible → shared_preferences ───────────
  themeMode(secure: false),
  locale(secure: false),
  onboardingCompleted(secure: false),
  onboardingSituation(secure: false),
  studentDetailJson(secure: false),
  lastSyncDate(secure: false),
  userPreferencesJson(secure: false),
  syncManifestJson(secure: false),
  fcmDeviceToken(secure: false),
  userProfileJson(secure: false),

  // ── Notifications ────────────────────────────────
  notificationsEnabled(secure: false),
  notificationsPermissionAsked(secure: false);

  const StorageKey({required this.secure});
  final bool secure;
}
