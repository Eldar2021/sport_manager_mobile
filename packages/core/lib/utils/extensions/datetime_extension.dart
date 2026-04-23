import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  /// Returns the date 7 days ago
  DateTime get aWeekAgo {
    return subtract(const Duration(days: 7));
  }

  /// Returns the date 30 days ago
  DateTime get aMonthAgo {
    return subtract(const Duration(days: 30));
  }

  /// Checks if 7 days have passed since this date
  bool isSevenDaysPassed(DateTime now) {
    final difference = now.difference(this);
    return difference.inDays >= 7;
  }
}

extension DateTimeXNullable on DateTime? {
  /// Format date to dd.MM.yyyy
  /// Example: 01.11.2025
  String? get dtStr {
    if (this == null) return null;
    return DateFormat('dd.MM.yyyy').format(this!);
  }

  /// Format DatTime to "HH:mm:ss"
  /// Example: 14:05:08
  String get timeStr {
    if (this == null) return '';
    return DateFormat('HH:mm:ss').format(this!);
  }

  /// Format DatTime to "dd.MM.yyyy HH:mm"
  /// Example: 01.11.2025 14:05
  String get fullDtStr {
    if (this == null) return '';
    return DateFormat('dd.MM.yyyy HH:mm').format(this!);
  }

  /// Format DatTime to "yyyy-MM-dd"
  /// Example: 2025-11-01
  String get apiString {
    if (this == null) return '';
    return DateFormat('yyyy-MM-dd').format(this!);
  }

  /// Format DatTime to "yyyy-MM-dd"
  /// Example: 2025-11-01
  String get apiStringWithTime {
    if (this == null) return '';
    return DateFormat('dd-MM-yyyy hh:mm:ss').format(this!);
  }

  String get toDayMonthYear {
    if (this == null) return '';
    return DateFormat('dd-MM-yyyy').format(this!);
  }

  /// Format DatTime to "dd-MM-yyyy"
  /// Example: 25-11-2025
  String get ddMMyyyy {
    if (this == null) return '';
    return DateFormat('dd-MM-yyyy').format(this!);
  }
}
