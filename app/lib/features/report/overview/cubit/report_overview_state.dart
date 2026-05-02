part of 'report_overview_cubit.dart';

@immutable
final class ReportOverviewState extends Equatable {
  const ReportOverviewState({
    required this.filter,
    this.venues = const RequestInitial(),
    this.summary = const RequestInitial(),
    this.revenue = const RequestInitial(),
    this.tables = const RequestInitial(),
    this.managers = const RequestInitial(),
    this.insights = const RequestInitial(),
    this.forecast = const RequestInitial(),
  });

  final ReportFilter filter;
  final RequestStatus<List<ReportVenueModel>> venues;
  final RequestStatus<ReportsSummaryModel> summary;
  final RequestStatus<List<RevenuePointModel>> revenue;
  final RequestStatus<List<TableReportRowModel>> tables;
  final RequestStatus<List<ManagerReportRowModel>> managers;
  final RequestStatus<List<InsightModel>> insights;
  final RequestStatus<ForecastModel> forecast;

  ReportOverviewState copyWith({
    ReportFilter? filter,
    RequestStatus<List<ReportVenueModel>>? venues,
    RequestStatus<ReportsSummaryModel>? summary,
    RequestStatus<List<RevenuePointModel>>? revenue,
    RequestStatus<List<TableReportRowModel>>? tables,
    RequestStatus<List<ManagerReportRowModel>>? managers,
    RequestStatus<List<InsightModel>>? insights,
    RequestStatus<ForecastModel>? forecast,
  }) {
    return ReportOverviewState(
      filter: filter ?? this.filter,
      venues: venues ?? this.venues,
      summary: summary ?? this.summary,
      revenue: revenue ?? this.revenue,
      tables: tables ?? this.tables,
      managers: managers ?? this.managers,
      insights: insights ?? this.insights,
      forecast: forecast ?? this.forecast,
    );
  }

  @override
  List<Object?> get props => [
    filter,
    venues,
    summary,
    revenue,
    tables,
    managers,
    insights,
    forecast,
  ];
}
