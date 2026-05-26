import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/core/observability/dev_overlay_toggle.dart';

class DevOverlayTrigger extends StatefulWidget {
  const DevOverlayTrigger({required this.child, super.key});

  final Widget child;

  @override
  State<DevOverlayTrigger> createState() => _DevOverlayTriggerState();
}

class _DevOverlayTriggerState extends State<DevOverlayTrigger> {
  static const _requiredLongPresses = 3;
  static const _resetWindow = Duration(seconds: 2);

  int _longPressCount = 0;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _onLongPress() {
    if (devOverlayEnabled.value) return;
    _longPressCount += 1;
    _resetTimer?.cancel();
    if (_longPressCount >= _requiredLongPresses) {
      _longPressCount = 0;
      devOverlayEnabled.value = true;
      return;
    }
    _resetTimer = Timer(_resetWindow, () => _longPressCount = 0);
  }

  void _onTap() {
    if (devOverlayEnabled.value) {
      devOverlayEnabled.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      onLongPress: _onLongPress,
      child: widget.child,
    );
  }
}
