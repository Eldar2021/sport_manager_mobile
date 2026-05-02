import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reports/reports.dart';

part 'report_overview_state.dart';

class ReportOverviewCubit extends Cubit<ReportOverviewState> {
  ReportOverviewCubit(ReportsRepository repository)
    : _repository = repository,
      super(ReportOverviewState(filter: ReportFilter.initial(DateTime.now())));

  final ReportsRepository _repository;

  Future<void> load() async {
    await Future.wait([
      loadVenues(),
      _refreshAll(),
    ]);
  }

  Future<void> loadVenues() async {
    emit(state.copyWith(venues: const RequestLoading()));
    try {
      final venues = await _repository.getVenues();
      emit(state.copyWith(venues: RequestSuccess(venues)));
    } on Object catch (e) {
      emit(state.copyWith(venues: RequestFailure(e)));
    }
  }

  Future<void> changePeriod(ReportPeriod period) async {
    final next = state.filter.copyWith(
      period: period,
      range: ReportRange.fromPeriod(period, DateTime.now()),
    );
    emit(state.copyWith(filter: next));
    await _refreshAll();
  }

  Future<void> changeVenue(String? venueId) async {
    final next = state.filter.copyWith(
      venueId: venueId,
      clearVenue: venueId == null,
    );
    emit(state.copyWith(filter: next));
    await _refreshAll();
  }

  Future<void> dismissInsight(String id) async {
    final current = state.insights.dataOrNull;
    if (current == null) return;
    final next = current.where((i) => i.id != id).toList(growable: false);
    emit(state.copyWith(insights: RequestSuccess(next)));
    try {
      await _repository.dismissInsight(id);
    } on Object catch (_) {
      emit(state.copyWith(insights: RequestSuccess(current)));
      rethrow;
    }
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      loadSummary(),
      loadRevenueSeries(),
      loadTopTables(),
      loadManagers(),
      loadInsights(),
      loadForecast(),
    ]);
  }

  Future<void> loadSummary() async {
    emit(state.copyWith(summary: const RequestLoading()));
    try {
      final summary = await _repository.getSummary(state.filter);
      emit(state.copyWith(summary: RequestSuccess(summary)));
    } on Object catch (e) {
      emit(state.copyWith(summary: RequestFailure(e)));
    }
  }

  Future<void> loadRevenueSeries() async {
    emit(state.copyWith(revenue: const RequestLoading()));
    try {
      final series = await _repository.getRevenueSeries(state.filter);
      emit(state.copyWith(revenue: RequestSuccess(series)));
    } on Object catch (e) {
      emit(state.copyWith(revenue: RequestFailure(e)));
    }
  }

  Future<void> loadTopTables() async {
    emit(state.copyWith(tables: const RequestLoading()));
    try {
      final tables = await _repository.getTopTables(state.filter);
      emit(state.copyWith(tables: RequestSuccess(tables)));
    } on Object catch (e) {
      emit(state.copyWith(tables: RequestFailure(e)));
    }
  }

  Future<void> loadManagers() async {
    emit(state.copyWith(managers: const RequestLoading()));
    try {
      final managers = await _repository.getManagers(state.filter);
      emit(state.copyWith(managers: RequestSuccess(managers)));
    } on Object catch (e) {
      emit(state.copyWith(managers: RequestFailure(e)));
    }
  }

  Future<void> loadInsights() async {
    emit(state.copyWith(insights: const RequestLoading()));
    try {
      final insights = await _repository.getInsights(state.filter);
      emit(state.copyWith(insights: RequestSuccess(insights)));
    } on Object catch (e) {
      emit(state.copyWith(insights: RequestFailure(e)));
    }
  }

  Future<void> loadForecast() async {
    emit(state.copyWith(forecast: const RequestLoading()));
    try {
      final forecast = await _repository.getForecast(state.filter);
      emit(state.copyWith(forecast: RequestSuccess(forecast)));
    } on Object catch (e) {
      emit(state.copyWith(forecast: RequestFailure(e)));
    }
  }
}
