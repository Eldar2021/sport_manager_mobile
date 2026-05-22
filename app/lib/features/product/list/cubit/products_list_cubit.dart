import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:product/product.dart';

part 'products_list_state.dart';

class ProductsListCubit extends Cubit<ProductsListState> {
  ProductsListCubit(ProductRepository productRepository)
    : _repository = productRepository,
      super(const ProductsListState());

  final ProductRepository _repository;

  Future<void> load({
    ProductCategory? category,
    bool clearCategory = false,
    String? search,
  }) async {
    final effectiveCategory = clearCategory ? null : (category ?? state.category);
    emit(
      state.copyWith(
        products: const RequestLoading(),
        category: effectiveCategory,
        clearCategory: clearCategory,
      ),
    );
    try {
      final products = await _repository.getAll(
        category: effectiveCategory,
        search: search,
      );
      emit(state.copyWith(products: RequestSuccess(products)));
    } on Object catch (e) {
      emit(state.copyWith(products: RequestFailure(e)));
    }
  }

  Future<void> delete(String id) async {
    if (state.deletingId != null) return;
    emit(state.copyWith(deletingId: id));
    try {
      await _repository.delete(id);
      final current = state.products.dataOrNull ?? const [];
      emit(
        state.copyWith(
          products: RequestSuccess(
            current.where((p) => p.id != id).toList(growable: false),
          ),
          clearDeletingId: true,
        ),
      );
    } on Object catch (_) {
      emit(state.copyWith(clearDeletingId: true));
      rethrow;
    }
  }
}
