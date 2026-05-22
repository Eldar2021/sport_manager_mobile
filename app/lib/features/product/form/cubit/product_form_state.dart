part of 'product_form_cubit.dart';

@immutable
final class ProductFormState extends Equatable {
  const ProductFormState({
    this.submitStatus = const RequestInitial(),
    this.uploadStatus = const RequestInitial(),
    this.photoUrl,
  });

  final RequestStatus<ProductModel> submitStatus;
  final RequestStatus<String> uploadStatus;
  final String? photoUrl;

  bool get isSubmitting => submitStatus is RequestLoading;
  bool get isUploading => uploadStatus is RequestLoading;

  ProductFormState copyWith({
    RequestStatus<ProductModel>? submitStatus,
    RequestStatus<String>? uploadStatus,
    String? photoUrl,
  }) {
    return ProductFormState(
      submitStatus: submitStatus ?? this.submitStatus,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [
    submitStatus,
    uploadStatus,
    photoUrl,
  ];
}
