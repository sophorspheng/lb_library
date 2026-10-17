import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService._();

  static final PreferencesService instance = PreferencesService._();

  static const _localeKey = 'app_locale';
  static const _themeModeKey = 'app_theme_mode';
  static const _notificationsEnabledKey = 'notifications_enabled';
  static const _rememberedEmailKey = 'remembered_login_email';

  Future<SharedPreferences> get _preferences => SharedPreferences.getInstance();

  Future<Locale> loadLocale() async {
    final languageCode = (await _preferences).getString(_localeKey);
    return switch (languageCode) {
      'km' => const Locale('km'),
      _ => const Locale('en'),
    };
  }

  Future<void> saveLocale(Locale locale) async {
    final languageCode = locale.languageCode;
    if (languageCode != 'en' && languageCode != 'km') {
      throw ArgumentError.value(locale, 'locale', 'Unsupported app locale');
    }
    _ensureSaved(
      await (await _preferences).setString(_localeKey, languageCode),
      _localeKey,
    );
  }

  Future<ThemeMode> loadThemeMode() async {
    final value = (await _preferences).getString(_themeModeKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    _ensureSaved(
      await (await _preferences).setString(_themeModeKey, mode.name),
      _themeModeKey,
    );
  }

  Future<bool> loadNotificationsEnabled() async {
    return (await _preferences).getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> saveNotificationsEnabled(bool enabled) async {
    _ensureSaved(
      await (await _preferences).setBool(_notificationsEnabledKey, enabled),
      _notificationsEnabledKey,
    );
  }

  Future<String?> loadRememberedEmail() async {
    return (await _preferences).getString(_rememberedEmailKey);
  }

  Future<void> saveRememberedEmail(String? email) async {
    final preferences = await _preferences;
    final normalizedEmail = email?.trim();
    if (normalizedEmail == null || normalizedEmail.isEmpty) {
      await preferences.remove(_rememberedEmailKey);
      return;
    }
    _ensureSaved(
      await preferences.setString(_rememberedEmailKey, normalizedEmail),
      _rememberedEmailKey,
    );
  }

  Future<void> clearAll() async {
    _ensureSaved(await (await _preferences).clear(), 'all preferences');
  }

  void _ensureSaved(bool success, String key) {
    if (!success) throw PreferencesException('Could not save "$key".');
  }
}

class PreferencesException implements Exception {
  const PreferencesException(this.message);

  final String message;

  @override
  String toString() => message;
}
