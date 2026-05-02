part of 'table_report_detail_cubit.dart';

@immutable
final class TableReportDetailState extends Equatable {
  const TableReportDetailState({
    required this.filter,
    this.detail = const RequestInitial(),
  });

  final ReportFilter filter;
  final RequestStatus<TableReportDetailModel> detail;

  TableReportDetailState copyWith({
    ReportFilter? filter,
    RequestStatus<TableReportDetailModel>? detail,
  }) {
    return TableReportDetailState(
      filter: filter ?? this.filter,
      detail: detail ?? this.detail,
    );
  }

  @override
  List<Object?> get props => [filter, detail];
}
