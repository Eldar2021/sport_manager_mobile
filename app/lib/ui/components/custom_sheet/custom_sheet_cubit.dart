import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sport_manager_mobile/core/core.dart';

typedef SheetItemFilter<T> = bool Function(T item, String query);

class CustomSheetCubit<T> extends Cubit<CustomSheetState<T>> {
  CustomSheetCubit({
    required Future<List<T>> Function() loader,
    SheetItemFilter<T>? searchFilter,
  }) : _loader = loader,
       _searchFilter = searchFilter,
       super(CustomSheetState<T>());

  final Future<List<T>> Function() _loader;
  final SheetItemFilter<T>? _searchFilter;

  Future<void> load() async {
    emit(state.copyWith(status: const DataLoading()));
    try {
      final items = await _loader();
      emit(
        state.copyWith(
          status: DataSuccess(items),
          filteredItems: _applyFilter(items, state.query),
        ),
      );
    } on Object catch (e) {
      emit(state.copyWith(status: DataFailure(e)));
    }
  }

  void search(String query) {
    emit(
      state.copyWith(
        query: query,
        filteredItems: _applyFilter(state.allItems, query),
      ),
    );
  }

  List<T> _applyFilter(List<T> items, String query) {
    final filter = _searchFilter;
    if (query.isEmpty || filter == null) return items;
    return items.where((item) => filter(item, query)).toList();
  }
}

@immutable
final class CustomSheetState<T> extends Equatable {
  const CustomSheetState({
    this.status = const DataInitial(),
    this.filteredItems = const [],
    this.query = '',
  });

  final DataState<List<T>> status;
  final List<T> filteredItems;
  final String query;

  List<T> get allItems => status.dataValue ?? const [];

  CustomSheetState<T> copyWith({
    DataState<List<T>>? status,
    List<T>? filteredItems,
    String? query,
  }) => CustomSheetState<T>(
    status: status ?? this.status,
    filteredItems: filteredItems ?? this.filteredItems,
    query: query ?? this.query,
  );

  @override
  List<Object?> get props => [status, filteredItems, query];
}
