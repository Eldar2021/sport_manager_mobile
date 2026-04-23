import 'package:equatable/equatable.dart';

sealed class RequestStatus<T> extends Equatable {
  const RequestStatus();

  bool get isInitial => this is RequestInitial<T>;
  bool get isLoading => this is RequestLoading<T>;
  bool get isSuccess => this is RequestSuccess<T>;
  bool get isFailure => this is RequestFailure<T>;

  T? get dataOrNull => switch (this) {
    RequestSuccess<T>(:final data) => data,
    _ => null,
  };

  @override
  List<Object?> get props => [];
}

final class RequestInitial<T> extends RequestStatus<T> {
  const RequestInitial();
}

final class RequestLoading<T> extends RequestStatus<T> {
  const RequestLoading();
}

final class RequestSuccess<T> extends RequestStatus<T> {
  const RequestSuccess(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

final class RequestFailure<T> extends RequestStatus<T> {
  const RequestFailure(this.exception);

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
