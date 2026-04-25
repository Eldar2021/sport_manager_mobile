import 'package:meta/meta.dart';
import 'package:sessions/models/session_status.dart';

@immutable
final class SessionsQuery {
  const SessionsQuery({
    this.venueId,
    this.tableId,
    this.managerId,
    this.from,
    this.to,
    this.status,
    this.page,
    this.limit,
  });

  final String? venueId;
  final String? tableId;
  final String? managerId;
  final DateTime? from;
  final DateTime? to;
  final SessionStatus? status;
  final int? page;
  final int? limit;

  Map<String, dynamic> toQueryParameters() {
    return {
      if (venueId != null) 'venueId': venueId,
      if (tableId != null) 'tableId': tableId,
      if (managerId != null) 'managerId': managerId,
      if (from != null) 'from': from!.toUtc().toIso8601String(),
      if (to != null) 'to': to!.toUtc().toIso8601String(),
      if (status != null) 'status': status!.name.toUpperCase(),
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    };
  }
}
