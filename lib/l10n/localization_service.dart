import 'package:flutter/material.dart';
import 'package:flutter_localization_sample/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static final LocalizationService _instance = LocalizationService._();
  LocalizationService._();
  factory LocalizationService() {
    return _instance;
  }

  final String _selectedLocaleKey = 'selected_locale';
  Locale _currentLocale = SupportedLocales.en;

  Locale get currentLocale => _currentLocale;

  Future<void> initialize() async {
    final savedLocale = await _getSavedLocale();
    _currentLocale = savedLocale ?? SupportedLocales.en;
    notifyListeners();
  }

  Future<Locale?> _getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_selectedLocaleKey);
    return savedLocale != null ? Locale(savedLocale) : null;
  }

  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLocaleKey, locale.languageCode);
  }

  Future<void> changeLocale(Locale locale) async {
    print('changeLocale called with locale: $locale');
    if (locale == _currentLocale) {
      print('locale is the same as currentLocale');
      return;
    }
    _currentLocale = locale;
    await _saveLocale(currentLocale);
    notifyListeners();
  }

  Future<void> reloadLocalizations() async {
    print('reloadLocalizations called');
    notifyListeners();
  }
}
