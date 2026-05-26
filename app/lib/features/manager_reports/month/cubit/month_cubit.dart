import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:sport_manager_mobile/core/core.dart';

class MonthCubit extends Cubit<DataState<MonthReportModel>> {
  MonthCubit(this._repo) : super(const DataInitial());

  final ManagerReportsRepository _repo;

  Future<void> load() async {
    if (state is! DataSuccess) emit(const DataLoading());
    try {
      final data = await _repo.getMonth();
      emit(DataSuccess(data));
    } on Object catch (e) {
      emit(DataFailure(e));
    }
  }
}
