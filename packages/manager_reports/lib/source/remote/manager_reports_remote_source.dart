import 'package:manager_reports/manager_reports.dart';

/// Remote source for "my own performance" reports. All endpoints are
/// scoped to `currentUser.id` server-side — owner & manager only ever
/// see their own sessions. The `timezone` argument is an IANA zone id
/// (`Asia/Bishkek` etc.); when null the backend uses its default.
abstract interface class ManagerReportsRemoteSource {
  Future<DayReportModel> getToday({String? timezone});

  Future<WeekReportModel> getWeek({String? timezone});

  Future<MonthReportModel> getMonth({String? timezone});

  Future<YearReportModel> getYear({String? timezone});

  /// `date` is interpreted in the user's local timezone (`YYYY-MM-DD`).
  Future<DayReportModel> getDayDetail(DateTime date, {String? timezone});

  /// `year` + `month` (1-12) → `YYYY-MM` on the wire.
  Future<MonthReportModel> getMonthDetail({
    required int year,
    required int month,
    String? timezone,
  });
}
