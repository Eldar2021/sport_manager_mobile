part of 'products_list_cubit.dart';

@immutable
final class ProductsListState extends Equatable {
  const ProductsListState({
    this.products = const RequestInitial(),
    this.category,
    this.deletingId,
  });

  final RequestStatus<List<ProductModel>> products;
  final ProductCategory? category;
  final String? deletingId;

  ProductsListState copyWith({
    RequestStatus<List<ProductModel>>? products,
    ProductCategory? category,
    bool clearCategory = false,
    String? deletingId,
    bool clearDeletingId = false,
  }) {
    return ProductsListState(
      products: products ?? this.products,
      category: clearCategory ? null : (category ?? this.category),
      deletingId: clearDeletingId ? null : (deletingId ?? this.deletingId),
    );
  }

  @override
  List<Object?> get props => [
    products,
    category,
    deletingId,
  ];
}
