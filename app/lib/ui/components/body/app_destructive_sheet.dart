import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppDestructiveSheet extends StatefulWidget {
  const AppDestructiveSheet({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.confirmLabel,
    required this.onConfirm,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String confirmLabel;
  final Future<void> Function() onConfirm;

  static Future<void> show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String confirmLabel,
    required Future<void> Function() onConfirm,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return AppDestructiveSheet(
          icon: icon,
          title: title,
          subtitle: subtitle,
          confirmLabel: confirmLabel,
          onConfirm: onConfirm,
        );
      },
    );
  }

  @override
  State<AppDestructiveSheet> createState() => _AppDestructiveSheetState();
}

class _AppDestructiveSheetState extends State<AppDestructiveSheet> {
  bool _isPerforming = false;

  Future<void> _onConfirm() async {
    if (_isPerforming) return;
    setState(() => _isPerforming = true);
    try {
      await widget.onConfirm();
    } finally {
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: !_isPerforming,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x6,
          AppSpacing.x6,
          AppSpacing.x6,
          AppSpacing.x8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: context.colors.error,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              widget.title,
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              widget.subtitle,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.x6),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isPerforming ? null : _onConfirm,
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.error,
                  disabledBackgroundColor: context.colors.error,
                  foregroundColor: context.colors.onError,
                  disabledForegroundColor: context.colors.onError,
                ),
                child: _isPerforming
                    ? SizedBox(
                        width: AppSpacing.x5,
                        height: AppSpacing.x5,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(context.colors.onError),
                        ),
                      )
                    : Text(widget.confirmLabel),
              ),
            ),
            const SizedBox(height: AppSpacing.x5),
            TextButton(
              onPressed: _isPerforming ? null : () => context.pop(),
              child: Text(
                l10n.cancel,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: _isPerforming ? context.colors.onSurfaceVariant : context.colors.primary,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.bottom(context)),
          ],
        ),
      ),
    );
  }
}
