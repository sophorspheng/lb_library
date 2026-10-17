import 'package:flutter/material.dart';
import 'package:lb_library/core/storage/preferences_service.dart';

final appLanguageController = LanguageController();

class LanguageController extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> loadSavedLocale() async {
    _locale = await PreferencesService.instance.loadLocale();
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    final previousLocale = _locale;
    _locale = locale;
    notifyListeners();
    try {
      await PreferencesService.instance.saveLocale(locale);
    } on Object {
      _locale = previousLocale;
      notifyListeners();
      rethrow;
    }
  }
}
