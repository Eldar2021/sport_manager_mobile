import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum PaymentStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('PAID')
  paid,
  @JsonValue('FAILED')
  failed,
}
