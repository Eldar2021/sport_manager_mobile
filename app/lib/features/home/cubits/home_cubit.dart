import 'dart:async';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sessions/sessions.dart';
import 'package:tables/tables.dart';
import 'package:venues/venues.dart';

part 'home_state.dart';

final class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._venueRepo,
    this._tableRepo,
    this._sessionRepo,
  ) : super(const HomeState());

  final VenueRepository _venueRepo;
  final TableRepository _tableRepo;
  final SessionRepository _sessionRepo;
  Timer? _ticker;

  Future<void> load() async {
    emit(
      state.copyWith(venuesStatus: const RequestLoading()),
    );
    try {
      final venues = await _venueRepo.getVenues();
      if (venues.isEmpty) {
        emit(
          state.copyWith(venuesStatus: RequestSuccess(venues)),
        );
        return;
      }
      final selected = venues.first;
      emit(
        state.copyWith(
          venuesStatus: RequestSuccess([]),
          selectedVenue: selected,
        ),
      );
      await _loadTables(selected);
    } on Object catch (e) {
      emit(state.copyWith(venuesStatus: RequestFailure(e)));
    }
  }

  Future<void> selectVenue(VenueModel venue) async {
    if (state.selectedVenue?.id == venue.id) return;
    _ticker?.cancel();
    emit(
      state.copyWith(
        selectedVenue: venue,
        tablesStatus: const RequestLoading(),
        activeSessions: const {},
      ),
    );
    await _loadTables(venue);
  }

  Future<void> refresh() async {
    if (state.selectedVenue == null) return load();
    await _loadTables(state.selectedVenue!);
  }

  Future<void> _loadTables(VenueModel venue) async {
    try {
      final results = await Future.wait<Object>([
        _tableRepo.getTables(venue.id),
        _sessionRepo.getActiveSessions(),
      ]);
      final tables = results[0] as List<TableModel>;
      final sessions = results[1] as List<SessionModel>;
      final sessionsMap = {
        for (final s in sessions.where((s) => s.venueId == venue.id)) s.tableId: s,
      };
      emit(
        state.copyWith(
          tablesStatus: RequestSuccess(tables),
          activeSessions: sessionsMap,
        ),
      );
      _startTicker();
    } on Object catch (e) {
      emit(
        state.copyWith(tablesStatus: RequestFailure(e)),
      );
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) emit(state.copyWith(tick: state.tick + 1));
    });
  }

  void markTableFreed(String tableId) {
    emit(
      state.copyWith(justFreedTableIds: {...state.justFreedTableIds, tableId}),
    );
    Future.delayed(const Duration(seconds: 5), () {
      if (!isClosed) {
        emit(
          state.copyWith(
            justFreedTableIds: {...state.justFreedTableIds}..remove(tableId),
          ),
        );
      }
    });
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
