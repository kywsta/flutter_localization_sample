# Localization in Flutter: Complete Development Guide

## Course Overview

This comprehensive guide walks you through implementing localization in Flutter applications step by step, based on real development progression. You'll learn how to create multilingual apps that can dynamically switch between languages and persist user language preferences.

## Learning Objectives

By the end of this course, you will be able to:

- Set up Flutter localization dependencies
- Create and manage ARB (Application Resource Bundle) files
- Generate localization classes automatically
- Implement dynamic language switching
- Persist user language preferences
- Build a complete localized Flutter application

---

## Step 1: Project Setup and Initial Dependencies

### 1.1 Create Flutter Project

Start with a basic Flutter project structure. The initial commit shows a standard Flutter app with:

- Basic `main.dart` with "Hello World" text
- Standard platform configurations (Android, iOS, Web, Desktop)
- Default `pubspec.yaml` with minimal dependencies

**Key Files Created:**

- `lib/main.dart` - Entry point with basic MaterialApp
- `pubspec.yaml` - Project configuration
- Platform-specific folders (android/, ios/, web/, etc.)

### 1.2 Add Localization Dependencies

The first step in implementing localization is adding the required dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations: # Flutter's localization framework
    sdk: flutter
  intl: ^0.20.2 # Internationalization utilities
```

**What these dependencies do:**

- `flutter_localizations`: Provides localization delegates and built-in translations
- `intl`: Handles date/time formatting, number formatting, and message translations

**Command to add dependencies:**

```bash
flutter pub add flutter_localizations --sdk=flutter
flutter pub add intl
```

---

## Step 2: Define Supported Locales

### 2.1 Create Constants File

Create a `lib/constants.dart` file to define your supported locales:

```dart
import 'package:flutter/material.dart';

class SupportedLocales {
  static const Locale en = Locale('en', 'US');
  static const Locale my = Locale('my', 'MM');

  static const List<Locale> all = [en, my];
}
```

**Best Practices:**

- Use standard language codes (ISO 639-1)
- Include country codes for regional variations
- Maintain a centralized list for easy management

### 2.2 Configure MaterialApp

Update your `main.dart` to include localization configuration:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localization_sample/constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Localization Sample',
      supportedLocales: SupportedLocales.all,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
```

**Key Components:**

- `supportedLocales`: List of locales your app supports
- `localizationsDelegates`: Delegates that provide localized resources

---

## Step 3: Create ARB Files and Localization Configuration

### 3.1 Configure l10n.yaml

Create a `l10n.yaml` file in your project root:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

**Configuration Options:**

- `arb-dir`: Directory containing ARB files
- `template-arb-file`: Template file (usually English)
- `output-localization-file`: Generated Dart file name

### 3.2 Create ARB Files

**English ARB file (`lib/l10n/app_en.arb`):**

```json
{
  "helloWorld": "Hello World!",
  "@helloWorld": {
    "description": "The conventional newborn programmer greeting"
  },
  "reload": "Reload",
  "nextPage": "Next Page",
  "nextPageTitle": "Page 2"
}
```

**Burmese ARB file (`lib/l10n/app_my.arb`):**

```json
{
  "helloWorld": "မင်္ဂလာပါ ကမ္ဘာကြီးရေ",
  "reload": "ပြန်လုပ်ပါ",
  "nextPage": "နောက်သို့",
  "nextPageTitle": "စာမျက်နှာ ၂"
}
```

**ARB File Structure:**

- Keys without `@` prefix: Actual translations
- Keys with `@` prefix: Metadata (descriptions, placeholders)
- Consistent keys across all language files

### 3.3 Generate Localization Classes

Run the following command to generate localization classes:

```bash
flutter pub get

or

flutter run
```

This generates:

- `lib/l10n/app_localizations.dart` - Main localization class
- `lib/l10n/app_localizations_en.dart` - English implementations
- `lib/l10n/app_localizations_my.dart` - Burmese implementations

---

## Step 4: Add Additional Dependencies for Advanced Features

### 4.1 Add State Management and Persistence

Add these dependencies for advanced localization features:

```yaml
dependencies:
  get_it: ^7.6.4 # Service locator for dependency injection
  shared_preferences: ^2.2.2 # For persisting language preferences
```

**Purpose:**

- `get_it`: Dependency injection for accessing localizations globally
- `shared_preferences`: Persist user's language choice across app restarts

---

## Step 5: Implement Localization Service

### 5.1 Create Localization Service

Create `lib/l10n/localization_service.dart`:

```dart
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
    if (locale == _currentLocale) return;

    _currentLocale = locale;
    await _saveLocale(currentLocale);
    notifyListeners();
  }

  Future<void> reloadLocalizations() async {
    notifyListeners();
  }
}
```

**Key Features:**

- Singleton pattern for global access
- Persistence using SharedPreferences
- ChangeNotifier for reactive updates
- Async initialization

### 5.2 Create Service Locator

Create `lib/service_locator.dart`:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_localization_sample/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void registerLocalizations(BuildContext context) {
  if (!serviceLocator.isRegistered<AppLocalizations>()) {
    serviceLocator.registerSingleton<AppLocalizations>(
      AppLocalizations.of(context)!
    );
  } else {
    serviceLocator.unregister<AppLocalizations>();
    serviceLocator.registerSingleton<AppLocalizations>(
      AppLocalizations.of(context)!
    );
  }
}
```

### 5.3 Create Localization Helper

Create `lib/l10n/localizations.dart`:

```dart
import 'package:flutter_localization_sample/l10n/app_localizations.dart';
import 'package:flutter_localization_sample/service_locator.dart';

AppLocalizations get localizations => serviceLocator<AppLocalizations>();
```

**Purpose:** Provides global access to localizations without BuildContext

---

## Step 6: Implement Complete Localized UI

### 6.1 Update Main Application

Update `lib/main.dart` with the complete implementation:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localization_sample/l10n/app_localizations.dart';
import 'package:flutter_localization_sample/l10n/localizations.dart';
import 'package:flutter_localization_sample/l10n/localization_service.dart';
import 'package:flutter_localization_sample/service_locator.dart';

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
        return MaterialApp(
          locale: LocalizationService().currentLocale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          onGenerateTitle: (context) {
            registerLocalizations(context);
            return 'Flutter Localization Sample';
          },
          home: HomePage(),
        );
      },
    );
  }
}
```

### 6.2 Create Home Page with Language Switching

```dart
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
```

### 6.3 Create Language Switcher Widget

```dart
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
```

---

## Step 7: Testing

1. **Test Language Switching:**

   - Tap the language switcher
   - Verify all text updates immediately
   - Check that preference is persisted after app restart

2. **Test Navigation:**

   - Ensure localization works across different screens
   - Verify that new screens show correct translations

## Conclusion

This guide demonstrated a complete Flutter localization implementation, from basic setup to advanced features like dynamic language switching and preference persistence. The step-by-step approach mirrors real-world development progression and provides a solid foundation for building multilingual Flutter applications.

### Next Steps

- Implement more complex translations with parameters
- Integrate with translation management platforms
- Add automated testing for localization features
