import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum Currency {
  @JsonValue('KGS')
  kgs,
  @JsonValue('USD')
  usd,
  @JsonValue('RUB')
  rub,
  @JsonValue('KZT')
  kzt,
  @JsonValue('TRY')
  tryLira
  ;

  String get label {
    return switch (this) {
      Currency.kgs => 'сом',
      Currency.usd => 'доллар',
      Currency.rub => 'рубль',
      Currency.kzt => 'тенге',
      Currency.tryLira => 'лира',
    };
  }
}
