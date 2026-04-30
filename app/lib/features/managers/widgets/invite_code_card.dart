import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class InviteCodeCard extends StatelessWidget {
  const InviteCodeCard(this.code, {super.key});

  final InviteCodeModel code;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: code.code));
    if (!context.mounted) return;
    context.showSuccessSnackBar(context.l10n.managersInviteCodeCopied);
  }

  @override
  Widget build(BuildContext context) {
    final onPrimary = context.colors.onPrimary;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: AppRadius.cardBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.managersInviteCodeLabel,
              style: context.textTheme.labelSmall?.copyWith(
                color: onPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              code.code,
              style: context.textTheme.displaySmall?.copyWith(
                color: onPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _copy(context),
                style: FilledButton.styleFrom(
                  backgroundColor: onPrimary.withValues(alpha: AppOpacity.tint),
                  foregroundColor: onPrimary,
                ),
                icon: const Icon(Icons.copy_rounded, size: AppSpacing.x4),
                label: Text(context.l10n.managersInviteCodeCopy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
