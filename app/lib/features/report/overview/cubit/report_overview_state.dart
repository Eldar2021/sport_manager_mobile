part of 'report_overview_cubit.dart';

@immutable
final class ReportOverviewState extends Equatable {
  const ReportOverviewState({
    required this.filter,
    this.venues = const RequestInitial(),
    this.summary = const RequestInitial(),
    this.revenue = const RequestInitial(),
    this.spots = const RequestInitial(),
    this.managers = const RequestInitial(),
    this.forecast = const RequestInitial(),
    this.products = const RequestInitial(),
  });

  final ReportFilter filter;
  final RequestStatus<List<ReportVenueModel>> venues;
  final RequestStatus<ReportsSummaryModel> summary;
  final RequestStatus<List<RevenuePointModel>> revenue;
  final RequestStatus<List<SpotReportRowModel>> spots;
  final RequestStatus<List<ManagerReportRowModel>> managers;
  final RequestStatus<ForecastModel> forecast;
  final RequestStatus<ProductReportSummaryModel> products;

  ReportOverviewState copyWith({
    ReportFilter? filter,
    RequestStatus<List<ReportVenueModel>>? venues,
    RequestStatus<ReportsSummaryModel>? summary,
    RequestStatus<List<RevenuePointModel>>? revenue,
    RequestStatus<List<SpotReportRowModel>>? spots,
    RequestStatus<List<ManagerReportRowModel>>? managers,
    RequestStatus<ForecastModel>? forecast,
    RequestStatus<ProductReportSummaryModel>? products,
  }) {
    return ReportOverviewState(
      filter: filter ?? this.filter,
      venues: venues ?? this.venues,
      summary: summary ?? this.summary,
      revenue: revenue ?? this.revenue,
      spots: spots ?? this.spots,
      managers: managers ?? this.managers,
      forecast: forecast ?? this.forecast,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [
    filter,
    venues,
    summary,
    revenue,
    spots,
    managers,
    forecast,
    products,
  ];
}
