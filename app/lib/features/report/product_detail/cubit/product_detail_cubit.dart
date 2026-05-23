import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:product/product.dart';
import 'package:reports/reports.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({
    required ProductRepository repository,
    required String venueId,
    required this.productId,
  }) : _repository = repository,
       _venueId = venueId,
       super(
         ProductDetailState(
           filter: ReportFilter.initial(
             DateTime.now(),
           ).copyWith(venueId: venueId),
         ),
       );

  final ProductRepository _repository;
  final String _venueId;
  final String productId;

  Future<void> load() async {
    emit(state.copyWith(detail: const RequestLoading()));
    try {
      final result = await _repository.getProductSalesReport(
        _venueId,
        productId,
        _toFilter(),
      );
      emit(state.copyWith(detail: RequestSuccess(result)));
    } on Object catch (e) {
      emit(state.copyWith(detail: RequestFailure(e)));
    }
  }

  Future<void> changePeriod(ReportPeriod period) async {
    final next = state.filter.copyWith(
      period: period,
      range: ReportRange.fromPeriod(period, DateTime.now()),
      compareToPrevious: period != ReportPeriod.today,
    );
    emit(state.copyWith(filter: next));
    await load();
  }

  ProductReportFilter _toFilter() => ProductReportFilter(
    period: state.filter.period.wireValue,
    from: state.filter.range.from.toIso8601String(),
    to: state.filter.range.to.toIso8601String(),
  );
}
