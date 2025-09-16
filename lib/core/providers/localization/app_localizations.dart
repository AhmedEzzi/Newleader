import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<void> load() async {
    try {
      String jsonString = await rootBundle.loadString(
        'assets/i18n/${locale.languageCode}.json',
      );
      
      // Debug print to check if the file is loaded
      debugPrint('Loaded translation file for ${locale.languageCode}');
      
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      
      // Debug print to check if translations were loaded properly
      debugPrint('Loaded ${_localizedStrings.length} translations');
    } catch (e) {
      debugPrint('Error loading translations: $e');
      _localizedStrings = {}; // Initialize with empty map on error
    }
  }

  String translate(String key) {
    final translation = _localizedStrings[key];
    if (translation == null) {
      // Debug print when a key is missing
      debugPrint('Missing translation key: $key for locale: ${locale.languageCode}');
      return key;
    }
    return translation;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Support only English and Arabic
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    debugPrint('Loading translations for locale: ${locale.languageCode}');
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true; // Change to true to force reload
}
