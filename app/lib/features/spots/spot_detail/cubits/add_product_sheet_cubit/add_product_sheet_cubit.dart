import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';

part 'add_product_sheet_state.dart';

final class _Absent {
  const _Absent();
}

const _absent = _Absent();

final class AddProductSheetCubit extends Cubit<AddProductSheetState> {
  AddProductSheetCubit(ProductRepository repository)
    : _repo = repository,
      super(
        const AddProductSheetState(),
      );

  final ProductRepository _repo;

  Future<void> load({ProductCategory? category}) async {
    emit(
      state.copyWith(
        products: const DataLoading(),
        selectedCategory: category,
      ),
    );
    try {
      final items = await _repo.getAll(category: category);
      emit(state.copyWith(products: DataSuccess(items)));
    } on Object catch (e) {
      emit(state.copyWith(products: DataFailure(e)));
    }
  }

  void selectCategory(ProductCategory? category) {
    load(category: category);
  }
}
