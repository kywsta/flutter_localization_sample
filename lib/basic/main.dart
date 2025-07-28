import 'package:flutter/material.dart';
import 'package:flutter_localization_sample/basic/language_selector.dart';
import 'package:flutter_localization_sample/basic/locale_provider.dart';
import 'package:flutter_localization_sample/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      builder: (context, child) {
        final locale = context.select<LocaleProvider, Locale>(
          (localeProvider) => localeProvider.locale,
        );

        return MaterialApp(
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final _emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homePageTitle),
        actions: [const LanguageSelector()],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(l10n.helloWorld),
          TextFormField(
            decoration: InputDecoration(labelText: l10n.emailInputLabel),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.invalidValue;
              }

              if (!RegExp(_emailRegex).hasMatch(value)) {
                return l10n.invalidValue;
              }

              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ],
      ),
    );
  }
}
