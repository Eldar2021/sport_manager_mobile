import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:product/product.dart';
import 'package:reports/reports.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({
    required ProductRepository repository,
    required String venueId,
    required ReportPeriod initialPeriod,
  }) : _repository = repository,
       _venueId = venueId,
       super(
         ProductsState(
           filter:
               ReportFilter.initial(
                 DateTime.now(),
               ).copyWith(
                 period: initialPeriod,
                 range: ReportRange.fromPeriod(
                   initialPeriod,
                   DateTime.now(),
                 ),
                 venueId: venueId,
               ),
         ),
       );

  final ProductRepository _repository;
  final String _venueId;

  Future<void> load() async {
    emit(state.copyWith(products: const RequestLoading()));
    try {
      final result = await _repository.getProductsReport(
        _venueId,
        _toFilter(),
      );
      emit(state.copyWith(products: RequestSuccess(result)));
    } on Object catch (e) {
      emit(state.copyWith(products: RequestFailure(e)));
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
    period: _periodValue(state.filter.period),
    from: state.filter.range.from.toUtc().toIso8601String(),
    to: state.filter.range.to.toUtc().toIso8601String(),
  );

  static String _periodValue(ReportPeriod period) {
    return switch (period) {
      ReportPeriod.today => 'day',
      ReportPeriod.week => 'week',
      ReportPeriod.month => 'month',
      ReportPeriod.year => 'year',
      ReportPeriod.custom => 'custom',
    };
  }
}
