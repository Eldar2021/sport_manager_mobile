import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum ProductUnit {
  @JsonValue('PIECE')
  piece,
  @JsonValue('KG')
  kg,
  @JsonValue('LITRE')
  litre,
  @JsonValue('PORTION')
  portion,
  @JsonValue('HOUR')
  hour,
}

extension ProductUnitJson on ProductUnit {
  String toJson() {
    return switch (this) {
      ProductUnit.piece => 'PIECE',
      ProductUnit.kg => 'KG',
      ProductUnit.litre => 'LITRE',
      ProductUnit.portion => 'PORTION',
      ProductUnit.hour => 'HOUR',
    };
  }
}
