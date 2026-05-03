import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgraderSheet extends StatelessWidget {
  const UpgraderSheet._({
    required this.status,
    required this.storeUrl,
    this.onDismiss,
  });

  final UpgradeStatusEnum status;
  final String storeUrl;
  final VoidCallback? onDismiss;

  static void show(
    BuildContext context,
    UpgradeStatusEnum status, {
    required String storeUrl,
    VoidCallback? onDismiss,
  }) {
    final isRequired = status == UpgradeStatusEnum.required;
    showModalBottomSheet<void>(
      context: context,
      isDismissible: !isRequired,
      enableDrag: !isRequired,
      builder: (_) => PopScope(
        canPop: !isRequired,
        child: UpgraderSheet._(
          status: status,
          storeUrl: storeUrl,
          onDismiss: onDismiss,
        ),
      ),
    );
  }

  Future<void> _launchStore() async {
    final uri = Uri.parse(storeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRequired = status == UpgradeStatusEnum.required;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x6,
        AppSpacing.x4,
        AppSpacing.x6,
        AppSpacing.x6 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isRequired ? context.l10n.upgraderRequiredTitle : context.l10n.upgraderRecommendedTitle,
            style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            isRequired ? context.l10n.upgraderRequiredDescription : context.l10n.upgraderRecommendedDescription,
            style: context.appTextStyles.muted.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x6),
          AppButton(
            onPressed: _launchStore,
            child: Text(context.l10n.upgraderUpdateButton),
          ),
          if (!isRequired) ...[
            const SizedBox(height: AppSpacing.x3),
            AppButton(
              variant: AppButtonVariant.outline,
              onPressed: () {
                Navigator.of(context).pop();
                onDismiss?.call();
              },
              child: Text(context.l10n.upgraderLaterButton),
            ),
          ],
        ],
      ),
    );
  }
}
