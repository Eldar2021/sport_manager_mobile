import 'package:facility/facility.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';

extension CurrencyX on Currency {
  String localizedName(AppLocalizations l10n) {
    return switch (this) {
      Currency.kgs => l10n.currencyKgs,
      Currency.usd => l10n.currencyUsd,
      Currency.rub => l10n.currencyRub,
      Currency.kzt => l10n.currencyKzt,
      Currency.tryLira => l10n.currencyTry,
    };
  }
}
