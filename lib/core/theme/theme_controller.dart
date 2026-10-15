
import 'package:flutter/material.dart';

final appThemeController = ThemeController();

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    setThemeMode(
      isDark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
