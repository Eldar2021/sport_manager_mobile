import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'session_product_item_model.g.dart';

@JsonSerializable()
@immutable
final class SessionProductItemModel extends Equatable {
  const SessionProductItemModel({
    required this.id,
    required this.sessionId,
    required this.productId,
    required this.nameSnapshot,
    required this.priceSnapshot,
    required this.addedAt,
  });

  factory SessionProductItemModel.fromJson(Map<String, dynamic> json) => _$SessionProductItemModelFromJson(json);

  final String id;
  final String sessionId;
  final String productId;
  final String nameSnapshot;
  final int priceSnapshot;
  final DateTime addedAt;

  Map<String, dynamic> toJson() => _$SessionProductItemModelToJson(this);

  @override
  List<Object?> get props => [id, sessionId, productId, nameSnapshot, priceSnapshot, addedAt];
}
