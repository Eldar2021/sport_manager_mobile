import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum UserRole {
  @JsonValue('OWNER')
  owner,
  @JsonValue('MANAGER')
  manager,
}
