import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
sealed class DataState<T> extends Equatable {
  const DataState();

  bool get isLoading => this is DataLoading;
  bool get isFailure => this is DataFailure;
  bool get isSuccess => this is DataSuccess;

  T? get dataValue => this is DataSuccess<T> ? (this as DataSuccess<T>).data : null;

  @override
  List<Object?> get props => [];
}

@immutable
final class DataInitial<T> extends DataState<T> {
  const DataInitial();
}

@immutable
final class DataLoading<T> extends DataState<T> {
  const DataLoading();
}

@immutable
final class DataSuccess<T> extends DataState<T> {
  const DataSuccess(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

@immutable
final class DataFailure<T> extends DataState<T> {
  const DataFailure(this.exception);

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
