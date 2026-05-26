import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/core/core.dart';

class TodayCubit extends Cubit<DataState<DayReportModel>> {
  TodayCubit(this._repo) : super(const DataInitial());

  final ManagerReportsRepository _repo;

  Future<void> load() async {
    if (state is! DataSuccess) emit(const DataLoading());
    try {
      final data = await _repo.getToday();
      emit(DataSuccess(data));
    } on Object catch (e) {
      emit(DataFailure(e));
    }
  }
}
