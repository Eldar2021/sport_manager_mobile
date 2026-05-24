part of 'product_detail_cubit.dart';

@immutable
final class ProductDetailState extends Equatable {
  const ProductDetailState({
    required this.filter,
    this.detail = const RequestInitial(),
  });

  final ReportFilter filter;
  final RequestStatus<ProductSalesSummaryModel> detail;

  ProductDetailState copyWith({
    ReportFilter? filter,
    RequestStatus<ProductSalesSummaryModel>? detail,
  }) {
    return ProductDetailState(
      filter: filter ?? this.filter,
      detail: detail ?? this.detail,
    );
  }

  @override
  List<Object?> get props => [
    filter,
    detail,
  ];
}
