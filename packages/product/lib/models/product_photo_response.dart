import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'product_photo_response.g.dart';

@JsonSerializable()
@immutable
final class ProductPhotoResponse extends Equatable {
  const ProductPhotoResponse(this.url);

  factory ProductPhotoResponse.fromJson(Map<String, dynamic> json) {
    return _$ProductPhotoResponseFromJson(json);
  }

  final String url;

  Map<String, dynamic> toJson() {
    return _$ProductPhotoResponseToJson(this);
  }

  @override
  List<Object?> get props => [url];
}
