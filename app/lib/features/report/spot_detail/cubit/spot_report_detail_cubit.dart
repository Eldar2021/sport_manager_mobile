import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reports/reports.dart';

part 'spot_report_detail_state.dart';

class SpotReportDetailCubit extends Cubit<SpotReportDetailState> {
  SpotReportDetailCubit({
    required ReportsRepository repository,
    required this.spotId,
    required String venueId,
  }) : _repository = repository,
       super(
         SpotReportDetailState(
           filter: ReportFilter.initial(DateTime.now()).copyWith(
             venueId: venueId,
           ),
         ),
       );

  final ReportsRepository _repository;
  final String spotId;

  Future<void> load() async {
    emit(state.copyWith(detail: const RequestLoading()));
    try {
      final detail = await _repository.getSpotDetail(
        spotId,
        state.filter,
      );
      emit(state.copyWith(detail: RequestSuccess(detail)));
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
}
