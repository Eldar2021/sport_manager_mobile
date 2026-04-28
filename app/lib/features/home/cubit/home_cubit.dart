import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.repository) : super(const HomeLoading());

  final FacilityRepository repository;

  Future<void> load() async {
    if (state is HomeLoading) return;

    try {
      emit(const HomeLoading());

      final response = await repository.getSelected();
      if (response.tables.isNotEmpty) {
        emit(
          HomeLoaded(
            venue: response.venue,
            tables: response.tables,
          ),
        );
      } else {
        emit(HomeNoTables(response.venue));
      }
    } on Object catch (e) {
      emit(HomeFailure(e));
    }
  }
}
