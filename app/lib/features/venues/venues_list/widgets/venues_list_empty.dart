import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenuesListEmpty extends StatelessWidget {
  const VenuesListEmpty(this.onPressed, {super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.modal),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x5),
              child: Icon(
                Icons.location_on_outlined,
                color: context.colors.primary,
                size: AppSpacing.x8,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Text(
            context.l10n.homeNoVenuesTitle,
            style: context.textTheme.headlineLarge?.copyWith(
              color: context.colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            context.l10n.homeNoVenuesSubtitle,
            style: context.appTextStyles.muted.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x8),
          AppButton(
            leading: const Icon(Icons.add_rounded),
            onPressed: onPressed,
            child: Text(context.l10n.homeCreateVenue),
          ),
        ],
      ),
    );
  }
}
