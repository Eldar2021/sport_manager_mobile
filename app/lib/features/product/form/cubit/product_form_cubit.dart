import 'dart:io';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:product/product.dart';

part 'product_form_state.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  ProductFormCubit({
    required ProductRepository productRepository,
    ProductModel? existing,
  }) : _repository = productRepository,
       _productId = existing?.id,
       super(
         ProductFormState(
           photoUrl: existing?.photoUrl,
           icon: existing?.icon,
         ),
       );

  final ProductRepository _repository;
  final String? _productId;

  Future<void> uploadPhoto(File file) async {
    if (state.isUploading) return;
    emit(
      ProductFormState(
        submitStatus: state.submitStatus,
        uploadStatus: const RequestLoading(),
      ),
    );
    try {
      final response = await _repository.uploadPhoto(file);
      emit(
        ProductFormState(
          submitStatus: state.submitStatus,
          uploadStatus: RequestSuccess(response.url),
          photoUrl: response.url,
        ),
      );
    } on Object catch (e) {
      emit(
        state.copyWith(
          uploadStatus: RequestFailure(e),
        ),
      );
    }
  }

  void removePhoto() {
    emit(
      ProductFormState(
        icon: state.icon,
        submitStatus: state.submitStatus,
      ),
    );
  }

  void setIcon(String? icon) {
    emit(
      ProductFormState(
        icon: icon,
        submitStatus: state.submitStatus,
        photoUrl: icon != null ? null : state.photoUrl,
        uploadStatus: icon != null ? const RequestInitial() : state.uploadStatus,
      ),
    );
  }

  Future<void> submit(ProductCreateParam param) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(submitStatus: const RequestLoading()));
    try {
      final result = _productId != null ? await _repository.update(_productId, param) : await _repository.create(param);
      emit(state.copyWith(submitStatus: RequestSuccess(result)));
    } on Object catch (e) {
      emit(state.copyWith(submitStatus: RequestFailure(e)));
    }
  }
}
