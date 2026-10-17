import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lb_library/core/storage/preferences_service.dart';
import 'package:lb_library/core/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lb_library/widgets/language_controller.dart';

void main() {
  final preferences = PreferencesService.instance;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('stores supported locale and falls back to English', () async {
    expect((await preferences.loadLocale()).languageCode, 'en');

    await preferences.saveLocale(const Locale('km'));
    expect((await preferences.loadLocale()).languageCode, 'km');

    await preferences.clearAll();
    expect((await preferences.loadLocale()).languageCode, 'en');
  });

  test('stores theme mode and defaults to system', () async {
    expect(await preferences.loadThemeMode(), ThemeMode.system);

    await preferences.saveThemeMode(ThemeMode.dark);
    expect(await preferences.loadThemeMode(), ThemeMode.dark);
  });

  test('stores notification preference and defaults to enabled', () async {
    expect(await preferences.loadNotificationsEnabled(), isTrue);

    await preferences.saveNotificationsEnabled(false);
    expect(await preferences.loadNotificationsEnabled(), isFalse);
  });

  test('stores remembered email without storing a password', () async {
    await preferences.saveRememberedEmail(' person@example.com ');
    expect(await preferences.loadRememberedEmail(), 'person@example.com');

    final store = await SharedPreferences.getInstance();
    expect(store.getString('remembered_login_password'), isNull);

    await preferences.saveRememberedEmail(null);
    expect(await preferences.loadRememberedEmail(), isNull);
  });

  test('app controllers persist and restore locale and theme', () async {
    await preferences.clearAll();
    await appLanguageController.loadSavedLocale();
    await appThemeController.loadSavedThemeMode();

    expect(appLanguageController.locale.languageCode, 'en');
    expect(appThemeController.themeMode, ThemeMode.system);

    await appLanguageController.setLocale(const Locale('km'));
    await appThemeController.setThemeMode(ThemeMode.dark);

    await appLanguageController.loadSavedLocale();
    await appThemeController.loadSavedThemeMode();

    expect(appLanguageController.locale.languageCode, 'km');
    expect(appThemeController.themeMode, ThemeMode.dark);
  });
}
