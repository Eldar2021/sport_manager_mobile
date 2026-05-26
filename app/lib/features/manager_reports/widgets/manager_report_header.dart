import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// Small uppercase eyebrow + larger period title shown directly above the
/// orange summary card. The caller composes the strings (locale + period
/// shape varies — "СЕГОДНЯ · ВОСКРЕСЕНЬЕ" vs "ЭТА НЕДЕЛЯ" vs "ЭТОТ МЕСЯЦ").
class ManagerReportHeader extends StatelessWidget {
  const ManagerReportHeader({
    required this.eyebrow,
    required this.title,
    super.key,
  });

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          eyebrow,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          title,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
