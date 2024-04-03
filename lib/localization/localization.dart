// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class DemoLocalization {
//   DemoLocalization(this.locale) {
//     // TODO: implement DemoLocalization
//     throw UnimplementedError();
//   }

//   final Locale locale;
//   static DemoLocalization? of(BuildContext context) {
//     return Localizations.of<DemoLocalization>(context, DemoLocalization);
//   }

//   Map<String, String> _localizedValues;

//   Future<void> load() async {
//     String jsonStringValues =
//         await rootBundle.loadString('lib/lang/${locale.languageCode}.json');
//     Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
//     _localizedValues =
//         mappedJson.map((key, value) => MapEntry(key, value.toString()));
//   }

//   String? translate(String key) {
//     return _localizedValues[key];
//   }

//   // static member to have simple access to the delegate from Material App
//   static const LocalizationsDelegate<DemoLocalization> delegate =
//       _DemoLocalizationsDelegate();
// }

// class _DemoLocalizationsDelegate
//     extends LocalizationsDelegate<DemoLocalization> {
//   const _DemoLocalizationsDelegate();

//   @override
//   bool isSupported(Locale locale) {
//     return ['en', 'fa', 'ar', 'hi'].contains(locale.languageCode);
//   }

//   @override
//   Future<DemoLocalization> load(Locale locale) async {
//     DemoLocalization localization = new DemoLocalization(locale);
//     await localization.load();
//     return localization;
//   }

//   @override
//   bool shouldReload(LocalizationsDelegate<DemoLocalization> old) => false;
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Future<void> load() async {
    String jsonString =
        await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
