import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

enum _AppEditDeleteAction { edit, delete }

class AppEditDeleteMenu extends StatelessWidget {
  const AppEditDeleteMenu({
    required this.onEdit,
    required this.onDelete,
    this.icon = Icons.more_vert_rounded,
    super.key,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_AppEditDeleteAction>(
      icon: Icon(icon),
      onSelected: (action) => switch (action) {
        _AppEditDeleteAction.edit => onEdit(),
        _AppEditDeleteAction.delete => onDelete(),
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _AppEditDeleteAction.edit,
          child: _MenuRow(
            icon: Icons.edit_outlined,
            color: context.colors.primary,
            label: context.l10n.menuEdit,
          ),
        ),
        PopupMenuItem(
          value: _AppEditDeleteAction.delete,
          child: _MenuRow(
            icon: Icons.delete_outline_rounded,
            color: context.colors.error,
            label: context.l10n.menuDelete,
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.x5),
        const SizedBox(width: AppSpacing.x3),
        Text(
          label,
          style: context.textTheme.bodyLarge?.copyWith(color: color),
        ),
      ],
    );
  }
}
