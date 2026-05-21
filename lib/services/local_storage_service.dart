import 'package:hive_flutter/hive_flutter.dart';

/// Centralized local storage service using Hive.
/// Manages "Remember Me" credentials and session persistence.
class LocalStorageService {
  static const String _authBoxName = 'auth';
  static const String _cardBoxName = 'saved_card';

  // Auth Keys
  static const String _keyRememberMe = 'remember_me';
  static const String _keyEmail = 'saved_email';
  static const String _keyPassword = 'saved_password';

  // Card Keys (CVC is NEVER stored)
  static const String _keyCardNumber = 'card_number';
  static const String _keyCardLast4 = 'card_last4';
  static const String _keyCardExpiry = 'card_expiry';
  static const String _keyCardHolder = 'card_holder';
  static const String _keyCardBrand = 'card_brand';

  /// Initialize Hive and open required boxes.
  /// Must be called once in main() before runApp.
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_authBoxName);
    await Hive.openBox(_cardBoxName);
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

  // ─── Saved Credit Card ───────────────────────────────────────

  static Box get _cardBox => Hive.box(_cardBoxName);

  /// Whether a card is currently saved.
  static bool get hasSavedCard =>
      _cardBox.get(_keyCardNumber) != null;

  /// Save card details locally. CVC is NEVER stored.
  static Future<void> saveCard({
    required String cardNumber,
    required String expiry,
    required String holderName,
    String? brand,
  }) async {
    final digitsOnly = cardNumber.replaceAll(' ', '');
    final last4 = digitsOnly.length >= 4
        ? digitsOnly.substring(digitsOnly.length - 4)
        : digitsOnly;
    await _cardBox.put(_keyCardNumber, digitsOnly);
    await _cardBox.put(_keyCardLast4, last4);
    await _cardBox.put(_keyCardExpiry, expiry);
    await _cardBox.put(_keyCardHolder, holderName);
    if (brand != null) await _cardBox.put(_keyCardBrand, brand);
  }

  /// Retrieve saved card data, or null if none saved.
  /// Returns a map with keys: number, last4, expiry, holder, brand.
  static Map<String, String>? getSavedCard() {
    final number = _cardBox.get(_keyCardNumber) as String?;
    if (number == null) return null;
    return {
      'number': number,
      'last4': _cardBox.get(_keyCardLast4, defaultValue: '') as String,
      'expiry': _cardBox.get(_keyCardExpiry, defaultValue: '') as String,
      'holder': _cardBox.get(_keyCardHolder, defaultValue: '') as String,
      'brand': _cardBox.get(_keyCardBrand, defaultValue: '') as String,
    };
  }

  /// Delete saved card.
  static Future<void> deleteCard() async {
    await _cardBox.delete(_keyCardNumber);
    await _cardBox.delete(_keyCardLast4);
    await _cardBox.delete(_keyCardExpiry);
    await _cardBox.delete(_keyCardHolder);
    await _cardBox.delete(_keyCardBrand);
  }
}
