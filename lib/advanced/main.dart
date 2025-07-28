import 'package:flutter/material.dart';
import 'package:flutter_localization_sample/l10n/app_localizations.dart';
import 'package:flutter_localization_sample/advanced/localizations.dart';
import 'package:flutter_localization_sample/advanced/localization_service.dart';
import 'package:flutter_localization_sample/advanced/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  LocalizationService().initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocalizationService(),
      builder: (context, child) {
        print('rebuilding app');
        return MaterialApp(
          locale: LocalizationService().currentLocale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          onGenerateTitle: (context) {
            print('received onGenerateTitle callback');
            registerLocalizations(context);
            return 'Flutter Localization Sample';
          },
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [_buildLanguageSwitcher()]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(localizations.helloWorld),
            const SizedBox(height: 20),
            _buildReloadButton(),
            const SizedBox(height: 20),
            _buildNextPageButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReloadButton() {
    return ElevatedButton(
      onPressed: () {
        LocalizationService().reloadLocalizations();
      },
      child: Text(localizations.reload),
    );
  }

  Widget _buildNextPageButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NextPage()),
        );
      },
      child: Text(localizations.nextPage),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [_buildLanguageSwitcher()],
      ),
      body: Center(child: Text(localizations.nextPageTitle)),
    );
  }
}

Widget _buildLanguageSwitcher() {
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
      LocalizationService().changeLocale(locale);
    },
  );
}
