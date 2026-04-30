import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProfileErrorView extends StatelessWidget {
  const ProfileErrorView({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final errorModel = GetIt.I<ErrorHandler>().parseErrorModel(error);
    return Card(
      color: context.colors.surface,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x8,
        ),
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: AppSpacing.x8,
                  color: context.colors.error,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              errorModel.title.getMessage(locale),
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              errorModel.message.getMessage(locale),
              textAlign: TextAlign.center,
              style: context.appTextStyles.muted.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.x5),
            AppButton(
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.medium,
              onPressed: onRetry,
              leading: const Icon(
                Icons.refresh_rounded,
                size: AppSpacing.x5,
              ),
              child: Text(context.l10n.generalRetry),
            ),
          ],
        ),
      ),
    );
  }
}
