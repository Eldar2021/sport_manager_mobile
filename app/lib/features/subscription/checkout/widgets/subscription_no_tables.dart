import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class SubscriptionNoSpots extends StatelessWidget {
  const SubscriptionNoSpots({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_bar_outlined,
            size: 56,
            color: context.colors.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            context.l10n.subscriptionCheckoutNoSpotsTitle,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            context.l10n.subscriptionCheckoutNoSpotsSubtitle,
            style: context.appTextStyles.muted.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x4),
          AppButton(
            expand: false,
            onPressed: () => context.go(AppRoutes.venuesList),
            child: Text(context.l10n.subscriptionCheckoutGoToVenues),
          ),
        ],
      ),
    );
  }
}
