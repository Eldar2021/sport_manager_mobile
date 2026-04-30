import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'checkout_param.g.dart';

@immutable
@JsonSerializable()
final class CheckoutParam extends Equatable {
  const CheckoutParam({required this.months});

  factory CheckoutParam.fromJson(Map<String, dynamic> json) {
    return _$CheckoutParamFromJson(json);
  }

  final int months;

  Map<String, dynamic> toJson() => _$CheckoutParamToJson(this);

  @override
  List<Object?> get props => [months];
}
