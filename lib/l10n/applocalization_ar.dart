import 'package:flutter/material.dart';

class AppLocalizations_ar {
  static AppLocalizations_ar? of(BuildContext context) {
    return Localizations.of<AppLocalizations_ar>(context, AppLocalizations_ar);
  }

  // Add your Arabic translations here
  String get hello {
    return 'مرحبا';
  }

  String get name {
    return 'الاسم';
  }

  // Add more translations as needed
}

class AppLocalizationsDelegate_ar
    extends LocalizationsDelegate<AppLocalizations_ar> {
  const AppLocalizationsDelegate_ar();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode.toLowerCase() == 'ar';
  }

  @override
  Future<AppLocalizations_ar> load(Locale locale) async {
    return AppLocalizations_ar();
  }

  @override
  bool shouldReload(AppLocalizationsDelegate_ar old) {
    return false;
  }
}
