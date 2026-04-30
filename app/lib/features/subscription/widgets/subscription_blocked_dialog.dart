import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

abstract final class SubscriptionBlockedDialog {
  static Future<void> show(BuildContext context) {
    return showAdaptiveDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog.adaptive(
        icon: Icon(Icons.lock_outline, color: dialogCtx.colors.error, size: 32),
        title: Text(dialogCtx.l10n.subscriptionBlockedTitle),
        content: Text(dialogCtx.l10n.subscriptionBlockedSubtitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(dialogCtx.l10n.subscriptionBlockedCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.push(AppRoutes.subscription);
            },
            child: Text(dialogCtx.l10n.subscriptionBlockedRenew),
          ),
        ],
      ),
    );
  }
}
