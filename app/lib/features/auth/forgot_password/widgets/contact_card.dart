import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/generated/assets.gen.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedRoundedBorderPainter(context.colors.outline),
      child: ListTile(
        onTap: onTap,
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        leading: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.primaryContainer,
            borderRadius: AppRadius.cardBorderRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Assets.icons.sms.svg(
              width: 24,
              colorFilter: ColorFilter.mode(
                context.colors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        title: Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: context.appTextStyles.muted.bodySmall,
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
