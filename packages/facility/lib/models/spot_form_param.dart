import 'package:equatable/equatable.dart';
import 'package:facility/models/currency.dart';
import 'package:facility/models/tarif_type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'spot_form_param.g.dart';

@immutable
@JsonSerializable(includeIfNull: false)
final class SpotFormParam extends Equatable {
  const SpotFormParam({
    required this.venueId,
    required this.number,
    required this.tarifAmount,
    required this.currency,
    required this.tarifType,
    this.name,
    this.description,
  });

  factory SpotFormParam.fromJson(Map<String, dynamic> json) {
    return _$SpotFormParamFromJson(json);
  }
  final String venueId;
  final int number;
  final String? name;
  final String? description;
  final int tarifAmount;
  final Currency currency;
  final TarifType tarifType;

  Map<String, dynamic> toJson() {
    return _$SpotFormParamToJson(this);
  }

  @override
  List<Object?> get props => [
    venueId,
    number,
    name,
    description,
    tarifAmount,
    currency,
    tarifType,
  ];
}
