// language_toggle_switch.dart

import 'package:flutter/material.dart';

class LanguageToggleSwitch extends StatelessWidget {
  final Function(Locale) onLanguageChanged;

  const LanguageToggleSwitch({super.key, required this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: Localizations.localeOf(context).languageCode == 'ar',
      onChanged: (value) {
        Locale newLocale =
            value ? const Locale('ar', 'SA') : const Locale('en', 'US');
        onLanguageChanged(newLocale);
      },
    );
  }
}
