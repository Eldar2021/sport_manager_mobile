part of 'add_product_sheet_cubit.dart';

@immutable
final class AddProductSheetState extends Equatable {
  const AddProductSheetState({
    this.products = const DataInitial(),
    this.selectedCategory,
  });

  final DataState<List<ProductModel>> products;
  final ProductCategory? selectedCategory;

  List<ProductModel> get items {
    return switch (products) {
      DataSuccess(:final data) => data,
      _ => const [],
    };
  }

  AddProductSheetState copyWith({
    DataState<List<ProductModel>>? products,
    Object? selectedCategory = _absent,
  }) {
    return AddProductSheetState(
      products: products ?? this.products,
      selectedCategory: selectedCategory is _Absent ? this.selectedCategory : selectedCategory as ProductCategory?,
    );
  }

  @override
  List<Object?> get props => [
    products,
    selectedCategory,
  ];
}
