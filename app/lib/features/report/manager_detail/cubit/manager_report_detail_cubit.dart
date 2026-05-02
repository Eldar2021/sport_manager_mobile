import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reports/reports.dart';

part 'manager_report_detail_state.dart';

class ManagerReportDetailCubit extends Cubit<ManagerReportDetailState> {
  ManagerReportDetailCubit({
    required ReportsRepository repository,
    required this.managerId,
  }) : _repository = repository,
       super(ManagerReportDetailState(filter: ReportFilter.initial(DateTime.now())));

  final ReportsRepository _repository;
  final String managerId;

  Future<void> load() async {
    emit(state.copyWith(detail: const RequestLoading()));
    try {
      final detail = await _repository.getManagerDetail(
        managerId,
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
    );
    emit(state.copyWith(filter: next));
    await load();
  }

  void changeLogFilter(ManagerLogFilter f) {
    emit(state.copyWith(logFilter: f));
  }
}
