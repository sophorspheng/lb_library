import 'package:flutter/material.dart';
import 'package:lb_library/core/storage/preferences_service.dart';

final appThemeController = ThemeController();

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadSavedThemeMode() async {
    _themeMode = await PreferencesService.instance.loadThemeMode();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    final previousMode = _themeMode;
    _themeMode = mode;
    notifyListeners();
    try {
      await PreferencesService.instance.saveThemeMode(mode);
    } on Object {
      _themeMode = previousMode;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> toggleTheme(bool isDark) {
    return setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
