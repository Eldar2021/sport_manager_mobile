import 'package:api_client/api_client.dart';
import 'package:meta/meta.dart';
import 'package:reports/reports.dart';

@immutable
final class ReportsRemoteSourceImpl implements ReportsRemoteSource {
  const ReportsRemoteSourceImpl(this._client);

  final ApiClient _client;

  static const _base = '/api/v1/reports';

  GetApiParams _params(ReportFilter f) {
    return GetApiParams(
      queryParameters: <String, dynamic>{
        if (f.venueId != null) 'venueId': f.venueId,
        'period': f.period.wireValue,
        'from': f.range.from.toUtc().toIso8601String(),
        'to': f.range.to.toUtc().toIso8601String(),
        'compare': f.compareToPrevious,
      },
    );
  }

  @override
  Future<List<ReportVenueModel>> getVenues() {
    return _client
        .getListOfType<ReportVenueModel>(
          '$_base/venues',
          fromJson: ReportVenueModel.fromJson,
        )
        .mapTo(ReportsExc.fromApiClientExc);
  }

  @override
  Future<ReportsSummaryModel> getSummary(ReportFilter filter) {
    return _client
        .getType<ReportsSummaryModel>(
          '$_base/overview',
          params: _params(filter),
          fromJson: ReportsSummaryModel.fromJson,
        )
        .mapTo(ReportsExc.fromApiClientExc);
  }

  @override
  Future<List<RevenuePointModel>> getRevenueSeries(ReportFilter filter) {
    return _client
        .getListOfType<RevenuePointModel>(
          '$_base/revenue-series',
          params: _params(filter),
          fromJson: RevenuePointModel.fromJson,
        )
        .mapTo(ReportsExc.fromApiClientExc);
  }

  @override
  Future<List<SpotReportRowModel>> getSpots(ReportFilter filter) {
    return _client
        .getListOfType<SpotReportRowModel>(
          '$_base/spots',
          params: _params(filter),
          fromJson: SpotReportRowModel.fromJson,
        )
        .mapTo(ReportsExc.fromApiClientExc);
  }

  @override
  Future<List<ManagerReportRowModel>> getManagers(ReportFilter filter) {
    return _client
        .getListOfType<ManagerReportRowModel>(
          '$_base/managers',
          params: _params(filter),
          fromJson: ManagerReportRowModel.fromJson,
        )
        .mapTo(ReportsExc.fromApiClientExc);
  }

  @override
  Future<ForecastModel> getForecast(ReportFilter filter) {
    return _client
        .getType<ForecastModel>(
          '$_base/forecast',
          params: _params(filter),
          fromJson: ForecastModel.fromJson,
        )
        .mapTo(ReportsExc.fromApiClientExc);
  }

  @override
  Future<ManagerReportDetailModel> getManagerDetail(
    String managerId,
    ReportFilter filter,
  ) {
    return _client
        .getType<ManagerReportDetailModel>(
          '$_base/managers/$managerId',
          params: _params(filter),
          fromJson: ManagerReportDetailModel.fromJson,
        )
        .mapTo(ReportsExc.fromApiClientExc);
  }

  @override
  Future<SpotReportDetailModel> getSpotDetail(
    String spotId,
    ReportFilter filter,
  ) {
    return _client
        .getType<SpotReportDetailModel>(
          '$_base/spots/$spotId',
          params: _params(filter),
          fromJson: SpotReportDetailModel.fromJson,
        )
        .mapTo(ReportsExc.fromApiClientExc);
  }
}
