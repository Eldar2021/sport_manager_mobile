import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/core/core.dart';

class DayDetailCubit extends Cubit<DataState<DayReportModel>> {
  DayDetailCubit(this._repo, this._date) : super(const DataInitial());

  final ManagerReportsRepository _repo;
  final DateTime _date;

  Future<void> load() async {
    if (state is! DataSuccess) emit(const DataLoading());
    try {
      final data = await _repo.getDayDetail(_date);
      emit(DataSuccess(data));
    } on Object catch (e) {
      emit(DataFailure(e));
    }
  }
}
