import 'dart:async';

import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SessionTimer extends StatefulWidget {
  const SessionTimer(this.session, {super.key});

  final SessionModel session;

  @override
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  final _elapsed = ValueNotifier<Duration>(Duration.zero);
  StreamSubscription<void>? _subscription;
  TextStyle? _style;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _style = context.textTheme.titleLarge?.copyWith(
      color: context.colors.error,
      fontWeight: FontWeight.w700,
      height: 1,
    );
  }

  @override
  void didUpdateWidget(SessionTimer old) {
    super.didUpdateWidget(old);
    if (old.session.id != widget.session.id || old.session.isPaused != widget.session.isPaused) {
      _sync();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _elapsed.dispose();
    super.dispose();
  }

  void _sync() {
    _subscription?.cancel();
    _tick();
    if (!widget.session.isPaused) {
      _subscription = Stream<void>.periodic(const Duration(seconds: 1)).listen(
        (_) => _tick(),
      );
    }
  }

  void _tick() {
    final Duration raw;
    if (widget.session.isPaused && widget.session.pausedAt != null) {
      raw =
          widget.session.pausedAt!.difference(widget.session.startedAt) -
          Duration(seconds: widget.session.totalPausedSeconds);
    } else {
      raw = DateTime.now().difference(widget.session.startedAt) - Duration(seconds: widget.session.totalPausedSeconds);
    }
    _elapsed.value = raw.isNegative ? Duration.zero : raw;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _elapsed,
      builder: (context, _) {
        final elapsed = _elapsed.value;
        final h = elapsed.inHours.toString().padLeft(2, '0');
        final m = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
        final s = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
        return Text('$h:$m:$s', style: _style);
      },
    );
  }
}
