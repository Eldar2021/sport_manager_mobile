import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum SubscriptionSource {
  @JsonValue('TRIAL')
  trial,
  @JsonValue('PAID')
  paid,
}
