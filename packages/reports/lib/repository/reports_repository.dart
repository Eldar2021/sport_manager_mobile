import 'package:meta/meta.dart';
import 'package:reports/reports.dart';

@immutable
final class ReportsRepository {
  const ReportsRepository(this._remote);

  final ReportsRemoteSource _remote;

  Future<List<ReportVenueModel>> getVenues() {
    return _remote.getVenues();
  }

  Future<ReportsSummaryModel> getSummary(ReportFilter filter) {
    return _remote.getSummary(filter);
  }

  Future<List<RevenuePointModel>> getRevenueSeries(ReportFilter filter) {
    return _remote.getRevenueSeries(filter);
  }

  Future<List<TableReportRowModel>> getTables(ReportFilter filter) {
    return _remote.getTables(filter);
  }

  Future<List<ManagerReportRowModel>> getManagers(ReportFilter filter) {
    return _remote.getManagers(filter);
  }

  Future<ForecastModel> getForecast(ReportFilter filter) {
    return _remote.getForecast(filter);
  }

  Future<ManagerReportDetailModel> getManagerDetail(
    String managerId,
    ReportFilter filter,
  ) {
    return _remote.getManagerDetail(managerId, filter);
  }

  Future<TableReportDetailModel> getTableDetail(
    String tableId,
    ReportFilter filter,
  ) {
    return _remote.getTableDetail(tableId, filter);
  }
}
