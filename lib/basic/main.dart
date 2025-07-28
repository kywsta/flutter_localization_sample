import 'package:flutter/material.dart';
import 'package:flutter_localization_sample/basic/language_selector.dart';
import 'package:flutter_localization_sample/basic/locale_provider.dart';
import 'package:flutter_localization_sample/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.helloWorld),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
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
          ),
          Divider(),
          _buildNumberText(context),
          _buildDateText(context),
        ],
      ),
    );
  }

  Widget _buildNumberText(BuildContext context) {
    final locale = Localizations.localeOf(context);

    final numberFormat = NumberFormat.decimalPattern(locale.toString());
    final currencyFormat = NumberFormat.currency(locale: locale.toString());
    final percentFormat = NumberFormat.percentPattern(locale.toString());
    final compactFormat = NumberFormat.compact(locale: locale.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Locale: ${locale.toString()}'),
        SizedBox(height: 16),
        Text('Number: ${numberFormat.format(1234567.89)}'),
        Text('Currency: ${currencyFormat.format(1234.56)}'),
        Text('Percent: ${percentFormat.format(0.75)}'),
        Text('Compact: ${compactFormat.format(1234567)}'),
      ],
    );
  }

  Widget _buildDateText(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final now = DateTime.now();

    final dateFormat = DateFormat.yMd(locale.toString());
    final timeFormat = DateFormat.jm(locale.toString());
    final dateTimeFormat = DateFormat.yMd(locale.toString()).add_jm();
    final longDateFormat = DateFormat.yMMMMEEEEd(locale.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Current DateTime: $now'),
        SizedBox(height: 16),

        Text('Date: ${dateFormat.format(now)}'),
        Text('Time: ${timeFormat.format(now)}'),
        Text('DateTime: ${dateTimeFormat.format(now)}'),
        Text('Long Date: ${longDateFormat.format(now)}'),

        SizedBox(height: 16),

        // Relative time
        Text(
          'Yesterday: ${dateFormat.format(now.subtract(Duration(days: 1)))}',
        ),
        Text('Next week: ${dateFormat.format(now.add(Duration(days: 7)))}'),
      ],
    );
  }
}
