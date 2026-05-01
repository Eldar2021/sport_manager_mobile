import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum PaymentOutcome {
  @JsonValue('PAID')
  paid,
  @JsonValue('FAILED')
  failed,
}
