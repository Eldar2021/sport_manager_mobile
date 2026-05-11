import 'package:talker_flutter/talker_flutter.dart';

/// Shared Talker instance — wired as a Dio interceptor and a GoRouter
/// observer in dev builds. Flutter framework errors are intentionally
/// **not** routed through Talker so the platform's own error reporting
/// stays the source of truth; Talker captures only REST + navigation.
final Talker talker = TalkerFlutter.init();
