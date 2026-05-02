import 'package:api_client/api_client.dart';
import 'package:meta/meta.dart';
import 'package:reports/reports.dart';

@immutable
final class ReportsRemoteSourceImpl implements ReportsRemoteSource {
  const ReportsRemoteSourceImpl(this._client);

  final ApiClient _client;

  static const _base = '/reports';

  GetApiParams _params(ReportFilter f) {
    return GetApiParams(
      queryParameters: <String, dynamic>{
        'from': f.range.from.toUtc().toIso8601String(),
        'to': f.range.to.toUtc().toIso8601String(),
        if (f.venueId != null) 'venueId': f.venueId,
        'compare': f.compareToPrevious,
      },
    );
  }

  @override
  Future<List<ReportVenueModel>> getVenues() {
    return _client.getListOfType<ReportVenueModel>(
      '$_base/venues',
      fromJson: ReportVenueModel.fromJson,
    );
  }

  @override
  Future<ReportsSummaryModel> getSummary(ReportFilter filter) {
    return _client.getType<ReportsSummaryModel>(
      '$_base/overview',
      params: _params(filter),
      fromJson: ReportsSummaryModel.fromJson,
    );
  }

  @override
  Future<List<RevenuePointModel>> getRevenueSeries(ReportFilter filter) {
    return _client.getListOfType<RevenuePointModel>(
      '$_base/revenue-series',
      params: _params(filter),
      fromJson: RevenuePointModel.fromJson,
    );
  }

  @override
  Future<List<TableReportRowModel>> getTables(ReportFilter filter) {
    return _client.getListOfType<TableReportRowModel>(
      '$_base/tables',
      params: _params(filter),
      fromJson: TableReportRowModel.fromJson,
    );
  }

  @override
  Future<List<ManagerReportRowModel>> getManagers(ReportFilter filter) {
    return _client.getListOfType<ManagerReportRowModel>(
      '$_base/managers',
      params: _params(filter),
      fromJson: ManagerReportRowModel.fromJson,
    );
  }

  @override
  Future<ForecastModel> getForecast(ReportFilter filter) {
    return _client.getType<ForecastModel>(
      '$_base/forecast',
      params: _params(filter),
      fromJson: ForecastModel.fromJson,
    );
  }

  @override
  Future<ManagerReportDetailModel> getManagerDetail(
    String managerId,
    ReportFilter filter,
  ) {
    return _client.getType<ManagerReportDetailModel>(
      '$_base/managers/$managerId',
      params: _params(filter),
      fromJson: ManagerReportDetailModel.fromJson,
    );
  }

  @override
  Future<TableReportDetailModel> getTableDetail(
    String tableId,
    ReportFilter filter,
  ) {
    return _client.getType<TableReportDetailModel>(
      '$_base/tables/$tableId',
      params: _params(filter),
      fromJson: TableReportDetailModel.fromJson,
    );
  }
}
