// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homePageTitle => 'Localization Sample';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get emailInputLabel => 'Email';

  @override
  String get invalidValue => 'Invalid value';

  @override
  String get reload => 'Reload';

  @override
  String get nextPage => 'Next Page';

  @override
  String get nextPageTitle => 'Page 2';
}
