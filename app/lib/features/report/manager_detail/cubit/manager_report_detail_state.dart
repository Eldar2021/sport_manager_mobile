part of 'manager_report_detail_cubit.dart';

/// Filters for the manager session log. MVP: just "all" and "cancelled"
/// — discount/short-cluster filters were intentionally cut along with
/// the fraud-signal removal.
enum ManagerLogFilter {
  all,
  cancelled,
}

@immutable
final class ManagerReportDetailState extends Equatable {
  const ManagerReportDetailState({
    required this.filter,
    this.detail = const RequestInitial(),
    this.logFilter = ManagerLogFilter.all,
  });

  final ReportFilter filter;
  final RequestStatus<ManagerReportDetailModel> detail;
  final ManagerLogFilter logFilter;

  ManagerReportDetailState copyWith({
    ReportFilter? filter,
    RequestStatus<ManagerReportDetailModel>? detail,
    ManagerLogFilter? logFilter,
  }) {
    return ManagerReportDetailState(
      filter: filter ?? this.filter,
      detail: detail ?? this.detail,
      logFilter: logFilter ?? this.logFilter,
    );
  }

  @override
  List<Object?> get props => [
    filter,
    detail,
    logFilter,
  ];
}
