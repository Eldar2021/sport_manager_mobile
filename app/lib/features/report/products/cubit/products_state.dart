part of 'products_cubit.dart';

@immutable
final class ProductsState extends Equatable {
  const ProductsState({
    required this.filter,
    this.products = const RequestInitial(),
  });

  final ReportFilter filter;
  final RequestStatus<ProductReportSummaryModel> products;

  ProductsState copyWith({
    ReportFilter? filter,
    RequestStatus<ProductReportSummaryModel>? products,
  }) {
    return ProductsState(
      filter: filter ?? this.filter,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [
    filter,
    products,
  ];
}
