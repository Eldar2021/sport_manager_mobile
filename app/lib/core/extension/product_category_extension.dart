import 'package:product/product.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';

extension ProductCategoryX on ProductCategory {
  String localizedName(AppLocalizations l10n) {
    return switch (this) {
      ProductCategory.drink => l10n.productCategoryDrink,
      ProductCategory.food => l10n.productCategoryFood,
      ProductCategory.equipment => l10n.productCategoryEquipment,
      ProductCategory.other => l10n.productCategoryOther,
    };
  }
}
