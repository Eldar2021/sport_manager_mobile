import 'package:api_client/api_client.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:meta/meta.dart';

@immutable
final class ManagerReportsRemoteSourceImpl implements ManagerReportsRemoteSource {
  const ManagerReportsRemoteSourceImpl(this._client);

  final ApiClient _client;

  static const _base = '/api/v1/manager-reports';

  GetApiParams _params({
    ManagerReportPeriod? period,
    String? timezone,
  }) {
    return GetApiParams(
      queryParameters: <String, dynamic>{
        if (period != null) 'period': period.wireValue,
        if (timezone != null && timezone.isNotEmpty) 'timezone': timezone,
      },
    );
  }

  @override
  Future<DayReportModel> getToday({String? timezone}) {
    return _client
        .getType<DayReportModel>(
          _base,
          params: _params(
            period: ManagerReportPeriod.today,
            timezone: timezone,
          ),
          fromJson: DayReportModel.fromJson,
        )
        .mapTo(ManagerReportsExc.fromApiClientExc);
  }

  @override
  Future<WeekReportModel> getWeek({String? timezone}) {
    return _client
        .getType<WeekReportModel>(
          _base,
          params: _params(
            period: ManagerReportPeriod.week,
            timezone: timezone,
          ),
          fromJson: WeekReportModel.fromJson,
        )
        .mapTo(ManagerReportsExc.fromApiClientExc);
  }

  @override
  Future<MonthReportModel> getMonth({String? timezone}) {
    return _client
        .getType<MonthReportModel>(
          _base,
          params: _params(
            period: ManagerReportPeriod.month,
            timezone: timezone,
          ),
          fromJson: MonthReportModel.fromJson,
        )
        .mapTo(ManagerReportsExc.fromApiClientExc);
  }

  @override
  Future<YearReportModel> getYear({String? timezone}) {
    return _client
        .getType<YearReportModel>(
          _base,
          params: _params(
            period: ManagerReportPeriod.year,
            timezone: timezone,
          ),
          fromJson: YearReportModel.fromJson,
        )
        .mapTo(ManagerReportsExc.fromApiClientExc);
  }

  @override
  Future<DayReportModel> getDayDetail(
    DateTime date, {
    String? timezone,
  }) {
    return _client
        .getType<DayReportModel>(
          '$_base/days/${_formatDate(date)}',
          params: _params(timezone: timezone),
          fromJson: DayReportModel.fromJson,
        )
        .mapTo(ManagerReportsExc.fromApiClientExc);
  }

  @override
  Future<MonthReportModel> getMonthDetail({
    required int year,
    required int month,
    String? timezone,
  }) {
    return _client
        .getType<MonthReportModel>(
          '$_base/months/${_formatYearMonth(year, month)}',
          params: _params(timezone: timezone),
          fromJson: MonthReportModel.fromJson,
        )
        .mapTo(ManagerReportsExc.fromApiClientExc);
  }

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String _formatYearMonth(int year, int month) {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    return '$y-$m';
  }
}
