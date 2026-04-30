import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:managers/managers.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ManagerCard extends StatelessWidget {
  const ManagerCard({
    required this.manager,
    required this.isDeleting,
    required this.onDelete,
    super.key,
  });

  final ManagerModel manager;
  final bool isDeleting;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = _avatarPalette(context, manager.id);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x1,
      ),
      leading: CircleAvatar(
        radius: AppSpacing.x6,
        backgroundColor: palette.background,
        child: Text(
          manager.avatarChar,
          style: context.textTheme.titleMedium?.copyWith(
            color: palette.foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(
        manager.name,
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.x1),
        child: Text(
          _subtitle(context),
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ),
      trailing: isDeleting
          ? const SizedBox(
              width: AppSpacing.x6,
              height: AppSpacing.x6,
              child: AppActivityIndicator(),
            )
          : IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.delete_outline_rounded,
                color: context.colors.error,
              ),
              tooltip: context.l10n.menuDelete,
            ),
    );
  }

  String _subtitle(BuildContext context) {
    final handle = '@${manager.username}';
    final lastSeen = manager.lastSeenAt;
    if (lastSeen == null) return handle;
    return '$handle · ${_formatLastSeen(context, lastSeen)}';
  }

  String _formatLastSeen(BuildContext context, DateTime lastSeen) {
    final l10n = context.l10n;
    final diff = DateTime.now().difference(lastSeen);
    if (diff.inMinutes < 1) return l10n.managersLastSeenJustNow;
    if (diff.inMinutes < 60) return l10n.managersLastSeenMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l10n.managersLastSeenHours(diff.inHours);
    if (diff.inDays < 7) return l10n.managersLastSeenDays(diff.inDays);
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(lastSeen);
  }

  _AvatarPalette _avatarPalette(BuildContext context, String seed) {
    final palettes = <_AvatarPalette>[
      _AvatarPalette(context.colors.primary, context.colors.onPrimary),
      _AvatarPalette(context.appColors.success, context.appColors.onSuccess),
      _AvatarPalette(context.appColors.warning, context.appColors.onWarning),
      _AvatarPalette(context.appColors.info, context.appColors.onInfo),
    ];
    return palettes[seed.hashCode.abs() % palettes.length];
  }
}

@immutable
class _AvatarPalette {
  const _AvatarPalette(
    this.background,
    this.foreground,
  );

  final Color background;
  final Color foreground;
}
