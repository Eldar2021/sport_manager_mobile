import 'package:equatable/equatable.dart';
import 'package:facility/facility.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manager_reports/manager_reports.dart';
import 'package:meta/meta.dart';

part 'day_card_model.g.dart';

/// A single day row in week / month lists. Backend always returns one card
/// per day in the window — even empty days (rest day, `isDayOff: true`).
@immutable
@JsonSerializable()
final class DayCardModel extends Equatable {
  const DayCardModel({
    required this.date,
    required this.dayOfWeek,
    required this.dayOfMonth,
    required this.shortDayOfWeek,
    required this.revenue,
    required this.currency,
    required this.sessions,
    required this.shiftSeconds,
    required this.isToday,
    required this.isFuture,
    required this.isDayOff,
  });

  factory DayCardModel.fromJson(Map<String, dynamic> json) => _$DayCardModelFromJson(json);

  final DateTime date;
  final DayOfWeek dayOfWeek;
  final int dayOfMonth;
  final DayOfWeekShort shortDayOfWeek;
  final int revenue;
  final Currency currency;
  final int sessions;
  final int shiftSeconds;
  final bool isToday;
  final bool isFuture;
  final bool isDayOff;

  Map<String, dynamic> toJson() => _$DayCardModelToJson(this);

  @override
  List<Object?> get props => [
    date,
    dayOfWeek,
    dayOfMonth,
    shortDayOfWeek,
    revenue,
    currency,
    sessions,
    shiftSeconds,
    isToday,
    isFuture,
    isDayOff,
  ];
}
