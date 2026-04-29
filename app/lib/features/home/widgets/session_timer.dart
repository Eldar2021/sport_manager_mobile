import 'dart:async';

import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SessionTimer extends StatefulWidget {
  const SessionTimer({required this.session, super.key});

  final SessionModel session;

  @override
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startOrFreezeTimer();
  }

  @override
  void didUpdateWidget(SessionTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session.isPaused != widget.session.isPaused || oldWidget.session.id != widget.session.id) {
      _timer?.cancel();
      _timer = null;
      _startOrFreezeTimer();
    }
  }

  void _startOrFreezeTimer() {
    _updateElapsed();
    if (!widget.session.isPaused) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateElapsed());
    }
  }

  void _updateElapsed() {
    final Duration raw;
    if (widget.session.isPaused && widget.session.pausedAt != null) {
      raw =
          widget.session.pausedAt!.difference(widget.session.startedAt) -
          Duration(seconds: widget.session.totalPausedSeconds);
    } else {
      raw = DateTime.now().difference(widget.session.startedAt) - Duration(seconds: widget.session.totalPausedSeconds);
    }
    final elapsed = raw.isNegative ? Duration.zero : raw;
    if (mounted) setState(() => _elapsed = elapsed);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = _elapsed.inHours.toString().padLeft(2, '0');
    final m = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return Text(
      '$h:$m:$s',
      style: context.textTheme.titleLarge?.copyWith(
        color: context.colors.error,
        fontWeight: FontWeight.w700,
        height: 1,
      ),
    );
  }
}
