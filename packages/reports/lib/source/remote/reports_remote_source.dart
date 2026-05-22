import 'package:reports/reports.dart';

abstract interface class ReportsRemoteSource {
  Future<List<ReportVenueModel>> getVenues();

  Future<ReportsSummaryModel> getSummary(ReportFilter filter);

  Future<List<RevenuePointModel>> getRevenueSeries(ReportFilter filter);

  Future<List<SpotReportRowModel>> getSpots(ReportFilter filter);

  Future<List<ManagerReportRowModel>> getManagers(ReportFilter filter);

  Future<ForecastModel> getForecast(ReportFilter filter);

  Future<ManagerReportDetailModel> getManagerDetail(
    String managerId,
    ReportFilter filter,
  );

  Future<SpotReportDetailModel> getSpotDetail(
    String spotId,
    ReportFilter filter,
  );
}
