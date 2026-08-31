import "package:shared_preferences/shared_preferences.dart";

class AuthLocalDataSource {
  const AuthLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const _userIdKey = "auth_user_id";
  static const _usernameKey = "auth_username";
  static const _onboardingKey = "auth_onboarding_completed";

  Future<void> saveSession({
    required String userId,
    required String username,
    required bool onboardingCompleted,
  }) async {
    await Future.wait([
      _prefs.setString(_userIdKey, userId),
      _prefs.setString(_usernameKey, username),
      _prefs.setBool(_onboardingKey, onboardingCompleted),
    ]);
  }

  String? getUserId() => _prefs.getString(_userIdKey);

  String? getUsername() => _prefs.getString(_usernameKey);

  bool isOnboardingCompleted() => _prefs.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_onboardingKey, completed);
  }

  Future<void> clearSession() async {
    await Future.wait([
      _prefs.remove(_userIdKey),
      _prefs.remove(_usernameKey),
      _prefs.remove(_onboardingKey),
    ]);
  }

  bool hasSession() => _prefs.containsKey(_userIdKey);
}
