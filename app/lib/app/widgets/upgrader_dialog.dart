import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class UpgraderDialog extends StatelessWidget {
  const UpgraderDialog({
    required this.status,
    this.onDismiss,
    super.key,
  });

  final UpgradeStatusEnum status;
  final VoidCallback? onDismiss;

  static void show(
    BuildContext context,
    UpgradeStatusEnum status, {
    VoidCallback? onDismiss,
  }) {
    final isRequired = status == UpgradeStatusEnum.required;
    showAdaptiveDialog<void>(
      context: context,
      barrierDismissible: !isRequired,
      builder: (_) => PopScope(
        canPop: !isRequired,
        child: UpgraderDialog(
          status: status,
          onDismiss: onDismiss,
        ),
      ),
    );
  }

  Future<void> _launchStore() async {
    final uri = Uri.parse(StoreUrls.current);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        log('UpgraderDialog: launchUrl returned false for $uri');
      }
    } on Object catch (e, s) {
      log('UpgraderDialog: failed to open store', error: e, stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRequired = status == UpgradeStatusEnum.required;
    return AlertDialog.adaptive(
      title: Text(
        isRequired ? context.l10n.upgraderRequiredTitle : context.l10n.upgraderRecommendedTitle,
        textAlign: TextAlign.center,
      ),
      content: Text(
        isRequired ? context.l10n.upgraderRequiredDescription : context.l10n.upgraderRecommendedDescription,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        if (!isRequired)
          _DialogAction(
            label: context.l10n.upgraderLaterButton,
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
          ),
        _DialogAction(
          label: context.l10n.upgraderUpdateButton,
          onPressed: _launchStore,
          isDefault: true,
        ),
      ],
    );
  }
}

class _DialogAction extends StatelessWidget {
  const _DialogAction({
    required this.label,
    required this.onPressed,
    this.isDefault = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isDefault;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoDialogAction(
        isDefaultAction: isDefault,
        onPressed: onPressed,
        child: Text(label),
      );
    }
    return TextButton(onPressed: onPressed, child: Text(label));
  }
}
