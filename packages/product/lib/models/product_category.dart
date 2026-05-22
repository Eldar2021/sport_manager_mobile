import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum ProductCategory {
  @JsonValue('DRINK')
  drink,
  @JsonValue('FOOD')
  food,
  @JsonValue('EQUIPMENT')
  equipment,
  @JsonValue('OTHER')
  other,
}

extension ProductCategoryJson on ProductCategory {
  String toJson() {
    return switch (this) {
      ProductCategory.drink => 'DRINK',
      ProductCategory.food => 'FOOD',
      ProductCategory.equipment => 'EQUIPMENT',
      ProductCategory.other => 'OTHER',
    };
  }

  IconData get icon {
    return switch (this) {
      ProductCategory.drink => Icons.local_drink_outlined,
      ProductCategory.food => Icons.restaurant_outlined,
      ProductCategory.equipment => Icons.sports_tennis_outlined,
      ProductCategory.other => Icons.shopping_bag_outlined,
    };
  }
}
