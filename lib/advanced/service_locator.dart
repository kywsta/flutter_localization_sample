import 'package:flutter/widgets.dart';
import 'package:flutter_localization_sample/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void registerLocalizations(BuildContext context) {
  if (!serviceLocator.isRegistered<AppLocalizations>()) {
    serviceLocator.registerSingleton<AppLocalizations>(AppLocalizations.of(context)!);
  } else {
    serviceLocator.unregister<AppLocalizations>();
    serviceLocator.registerSingleton<AppLocalizations>(AppLocalizations.of(context)!);
  }
}