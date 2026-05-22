import 'package:product/product.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';

extension ProductUnitX on ProductUnit {
  String localizedName(AppLocalizations l10n) {
    return switch (this) {
      ProductUnit.piece => l10n.productUnitPiece,
      ProductUnit.kg => l10n.productUnitKg,
      ProductUnit.litre => l10n.productUnitLitre,
      ProductUnit.portion => l10n.productUnitPortion,
      ProductUnit.hour => l10n.productUnitHour,
    };
  }

  String localizedShortName(AppLocalizations l10n) {
    return switch (this) {
      ProductUnit.piece => l10n.productUnitPieceShort,
      ProductUnit.kg => l10n.productUnitKgShort,
      ProductUnit.litre => l10n.productUnitLitreShort,
      ProductUnit.portion => l10n.productUnitPortionShort,
      ProductUnit.hour => l10n.productUnitHourShort,
    };
  }
}
