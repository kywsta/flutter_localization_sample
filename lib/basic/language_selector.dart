
import 'package:flutter/material.dart';
import 'package:flutter_localization_sample/basic/locale_provider.dart';
import 'package:flutter_localization_sample/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current locale from the LocaleProvider
    final localeProvider = context.watch<LocaleProvider>();

    return PopupMenuButton(
    icon: const Icon(Icons.language),
    itemBuilder: (context) => AppLocalizations.supportedLocales
        .map(
          (locale) => PopupMenuItem(
            value: locale,
            child: Text(locale.languageCode.toUpperCase()),
          ),
        )
        .toList(),
    onSelected: (locale) {
      // Set the new locale and notify the UI to rebuild
      localeProvider.setLocale(locale);
    },
  );
  }
}