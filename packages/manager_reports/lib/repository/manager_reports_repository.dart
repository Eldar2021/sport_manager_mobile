import 'package:manager_reports/manager_reports.dart';
import 'package:meta/meta.dart';

@immutable
final class ManagerReportsRepository {
  const ManagerReportsRepository(this._remote);

  final ManagerReportsRemoteSource _remote;

  Future<DayReportModel> getToday({String? timezone}) => _remote.getToday(timezone: timezone);

  Future<WeekReportModel> getWeek({String? timezone}) => _remote.getWeek(timezone: timezone);

  Future<MonthReportModel> getMonth({String? timezone}) => _remote.getMonth(timezone: timezone);

  Future<YearReportModel> getYear({String? timezone}) => _remote.getYear(timezone: timezone);

  Future<DayReportModel> getDayDetail(DateTime date, {String? timezone}) {
    return _remote.getDayDetail(date, timezone: timezone);
  }

  Future<MonthReportModel> getMonthDetail({
    required int year,
    required int month,
    String? timezone,
  }) {
    return _remote.getMonthDetail(year: year, month: month, timezone: timezone);
  }
}
