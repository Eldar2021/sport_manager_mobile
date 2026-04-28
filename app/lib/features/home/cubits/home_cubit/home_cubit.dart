import 'dart:async';

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

final class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.repository) : super(const HomeState());

  final FacilityRepository repository;
  Timer? _ticker;

  Future<void> load() async {
    emit(state.copyWith(selectedStatus: const RequestLoading()));
    try {
      final response = await repository.getSelected();
      emit(state.copyWith(selectedStatus: RequestSuccess(response)));
      if (response.tables.isNotEmpty) _startTicker();
    } on Object catch (e) {
      emit(state.copyWith(selectedStatus: RequestFailure(e)));
    }
  }

  Future<void> selectVenue(VenueModel venue) async {
    if (state.selectedVenue?.id == venue.id) return;
    _ticker?.cancel();
    emit(state.copyWith(selectedStatus: const RequestLoading()));
    try {
      final response = await repository.updateSelected(venue.id);
      emit(state.copyWith(selectedStatus: RequestSuccess(response)));
      if (response.tables.isNotEmpty) _startTicker();
    } on Object catch (e) {
      emit(state.copyWith(selectedStatus: RequestFailure(e)));
    }
  }

  Future<void> refresh() => load();

  void markTableFreed(String tableId) {
    emit(state.copyWith(justFreedTableIds: {...state.justFreedTableIds, tableId}));
    Future.delayed(const Duration(seconds: 5), () {
      if (!isClosed) {
        emit(
          state.copyWith(justFreedTableIds: {...state.justFreedTableIds}..remove(tableId)),
        );
      }
    });
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) emit(state.copyWith(tick: state.tick + 1));
    });
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
