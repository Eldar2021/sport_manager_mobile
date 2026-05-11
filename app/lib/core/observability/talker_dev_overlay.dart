import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/core/observability/app_talker.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Dev-only floating button that surfaces the [TalkerScreen] from any
/// route. Pushed via the root [Navigator] so it works inside nested
/// shell branches. Auto-hides while the soft keyboard is open so it
/// doesn't fight form submit FABs.
class TalkerDevOverlay extends StatelessWidget {
  const TalkerDevOverlay(this.navigatorKey, {super.key});

  final GlobalKey<NavigatorState> navigatorKey;

  void _open() {
    navigatorKey.currentState?.push(
      MaterialPageRoute<void>(builder: (_) => TalkerScreen(talker: talker)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    if (mq.viewInsets.bottom > 0) return const SizedBox.shrink();
    return Positioned(
      right: AppSpacing.x3,
      bottom: AppSpacing.x16 + AppSpacing.x4 + mq.viewPadding.bottom,
      child: Material(
        color: context.colors.primary.withValues(alpha: 0.85),
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          onTap: _open,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x2),
            child: Icon(
              Icons.bug_report_outlined,
              size: 20,
              color: context.colors.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
