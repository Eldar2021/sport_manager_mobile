import 'package:flutter/widgets.dart';
import 'package:sport_manager_mobile/l10n/generated/app_localizations.dart';

export 'package:sport_manager_mobile/l10n/generated/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

final class AppLocalizationHelper {
  const AppLocalizationHelper._();

  static const locales = <Locale>[Locale('en'), Locale('ky'), Locale('ru')];

  static String getName(String? code) {
    return switch (code) {
      'en' => 'English',
      'ky' => 'Кыргызча',
      'ru' => 'Русский',
      _ => 'English',
    };
  }

  static bool isSupported(String locale) {
    return switch (locale) {
      'en' || 'ky' || 'ru' => true,
      _ => false,
    };
  }

  static Locale getSupportedLocale(String locale) {
    if (isSupported(locale)) return Locale(locale);
    return const Locale('en');
  }
}
