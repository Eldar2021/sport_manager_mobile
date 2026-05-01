import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum SubscriptionStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('GRACE')
  grace,
  @JsonValue('EXPIRED')
  expired,
}
