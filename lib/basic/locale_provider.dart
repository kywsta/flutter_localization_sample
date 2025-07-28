import 'package:flutter/material.dart';
import 'package:flutter_localization_sample/l10n/app_localizations.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = AppLocalizations.supportedLocales.first;

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!supportedLocales.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = AppLocalizations.supportedLocales.first;
    notifyListeners();
  }

  static const List<Locale> supportedLocales = AppLocalizations.supportedLocales;
}
