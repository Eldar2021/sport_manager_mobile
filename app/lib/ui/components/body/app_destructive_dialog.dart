import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AppDestructiveDialog extends StatefulWidget {
  const AppDestructiveDialog({
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
    return showDialog<void>(
      context: context,
      builder: (_) => AppDestructiveDialog(
        icon: icon,
        title: title,
        subtitle: subtitle,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<AppDestructiveDialog> createState() => _AppDestructiveDialogState();
}

class _AppDestructiveDialogState extends State<AppDestructiveDialog> {
  bool _isPerforming = false;

  Future<void> _onConfirm() async {
    if (_isPerforming) return;
    setState(() => _isPerforming = true);
    try {
      await widget.onConfirm();
    } finally {
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isPerforming,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x4),
                  child: Icon(
                    widget.icon,
                    color: context.colors.error,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                widget.title,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                widget.subtitle,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.x6),
              Row(
                spacing: AppSpacing.x3,
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: _isPerforming ? null : () => Navigator.of(context).pop(),
                      child: Text(context.l10n.cancel),
                    ),
                  ),
                  Expanded(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
