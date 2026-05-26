import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/core/core.dart';

class MonthDetailCubit extends Cubit<DataState<MonthReportModel>> {
  MonthDetailCubit(
    this._repo,
    this._year,
    this._month,
  ) : super(const DataInitial());

  final ManagerReportsRepository _repo;
  final int _year;
  final int _month;

  Future<void> load() async {
    if (state is! DataSuccess) emit(const DataLoading());
    try {
      final data = await _repo.getMonthDetail(
        year: _year,
        month: _month,
      );
      emit(DataSuccess(data));
    } on Object catch (e) {
      emit(DataFailure(e));
    }
  }
}
