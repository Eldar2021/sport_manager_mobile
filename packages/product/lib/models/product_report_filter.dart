import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
final class ProductReportFilter extends Equatable {
  const ProductReportFilter({
    this.period,
    this.from,
    this.to,
  });

  final String? period;
  final String? from;
  final String? to;

  @override
  List<Object?> get props => [
    period,
    from,
    to,
  ];
}
