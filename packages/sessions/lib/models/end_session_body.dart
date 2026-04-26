import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'end_session_body.g.dart';

@immutable
@JsonSerializable(includeIfNull: false)
final class EndSessionBody extends Equatable {
  const EndSessionBody({this.discountPercent});

  factory EndSessionBody.fromJson(Map<String, dynamic> json) {
    return _$EndSessionBodyFromJson(json);
  }

  /// 0–100. Если null — скидки нет.
  final int? discountPercent;

  Map<String, dynamic> toJson() {
    return _$EndSessionBodyToJson(this);
  }

  @override
  List<Object?> get props => [discountPercent];
}
