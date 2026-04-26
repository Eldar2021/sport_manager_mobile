import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class VenuesEmptyWidget extends StatelessWidget {
  const VenuesEmptyWidget({required this.onCreateTap, super.key});

  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colors.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.x5),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: context.colors.primary,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x5),
                  Text(
                    l10n.homeNoVenuesTitle,
                    style: context.textTheme.headlineLarge?.copyWith(color: context.colors.onSurface),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    l10n.homeNoVenuesSubtitle,
                    style: context.textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.x8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
                    child: FilledButton(
                      onPressed: onCreateTap,
                      child: Text(l10n.homeCreateVenue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
