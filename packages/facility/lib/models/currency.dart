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
  tryLira,
}
