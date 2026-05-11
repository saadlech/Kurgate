import 'package:hive_flutter/hive_flutter.dart';

/// Centralized local storage service using Hive.
/// Manages "Remember Me" credentials and session persistence.
class LocalStorageService {
  static const String _authBoxName = 'auth';

  // Keys
  static const String _keyRememberMe = 'remember_me';
  static const String _keyEmail = 'saved_email';
  static const String _keyPassword = 'saved_password';

  /// Initialize Hive and open required boxes.
  /// Must be called once in main() before runApp.
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_authBoxName);
  }

  // ─── Auth / Remember Me ──────────────────────────────────────

  static Box get _authBox => Hive.box(_authBoxName);

  /// Save credentials when "Remember Me" is checked.
  static Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _authBox.put(_keyRememberMe, true);
    await _authBox.put(_keyEmail, email);
    await _authBox.put(_keyPassword, password);
  }

  /// Clear saved credentials (on logout or when unchecked).
  static Future<void> clearCredentials() async {
    await _authBox.put(_keyRememberMe, false);
    await _authBox.delete(_keyEmail);
    await _authBox.delete(_keyPassword);
  }

  /// Whether the user has opted into "Remember Me".
  static bool get isRememberMeEnabled =>
      _authBox.get(_keyRememberMe, defaultValue: false) as bool;

  /// Retrieve saved email, or null if none.
  static String? get savedEmail =>
      _authBox.get(_keyEmail) as String?;

  /// Retrieve saved password, or null if none.
  static String? get savedPassword =>
      _authBox.get(_keyPassword) as String?;
}
