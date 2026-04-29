import 'package:facility/facility.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';

extension TarifTypeX on TarifType {
  String localizedUnit(AppLocalizations l10n) {
    return switch (this) {
      TarifType.minute => l10n.tarifTypeMinute,
      TarifType.hour => l10n.tarifTypeHour,
      TarifType.day => l10n.tarifTypeDay,
    };
  }
}
