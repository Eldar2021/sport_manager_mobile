import 'package:reports/reports.dart';

abstract interface class ReportsRemoteSource {
  Future<List<ReportVenueModel>> getVenues();

  Future<ReportsSummaryModel> getSummary(ReportFilter filter);

  Future<List<RevenuePointModel>> getRevenueSeries(ReportFilter filter);

  Future<List<TableReportRowModel>> getTopTables(
    ReportFilter filter, {
    int limit = 5,
  });

  Future<List<ManagerReportRowModel>> getManagers(ReportFilter filter);

  Future<List<InsightModel>> getInsights(ReportFilter filter);

  Future<ForecastModel> getForecast(ReportFilter filter);

  Future<ManagerReportDetailModel> getManagerDetail(
    String managerId,
    ReportFilter filter,
  );

  Future<TableReportDetailModel> getTableDetail(
    String tableId,
    ReportFilter filter,
  );

  Future<void> dismissInsight(String id);
}
