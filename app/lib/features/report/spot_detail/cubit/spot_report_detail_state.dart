part of 'spot_report_detail_cubit.dart';

@immutable
final class SpotReportDetailState extends Equatable {
  const SpotReportDetailState({
    required this.filter,
    this.detail = const RequestInitial(),
  });

  final ReportFilter filter;
  final RequestStatus<SpotReportDetailModel> detail;

  SpotReportDetailState copyWith({
    ReportFilter? filter,
    RequestStatus<SpotReportDetailModel>? detail,
  }) {
    return SpotReportDetailState(
      filter: filter ?? this.filter,
      detail: detail ?? this.detail,
    );
  }

  @override
  List<Object?> get props => [filter, detail];
}
