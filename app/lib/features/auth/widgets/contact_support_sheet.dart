import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sport_manager_mobile/generated/assets.gen.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ContactSupportSheet extends StatelessWidget {
  const ContactSupportSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const ContactSupportSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x6,
        0,
        AppSpacing.x6,
        AppSpacing.x6 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.authContactSupportTitle,
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            l10n.authContactSupportSubtitle,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.x4),
          const Divider(),
          _ContactItem(
            icon: Assets.icons.whatsapp.svg(
              width: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFF41d365),
                BlendMode.srcIn,
              ),
            ),
            iconBgColor: const Color(0xFFeefcf4),
            title: 'WhatsApp',
            subtitle: '+996 702 31-36-11',
            onTap: () {},
          ),
          const Divider(),

          _ContactItem(
            icon: Assets.icons.telegram.svg(
              width: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFF369ed9),
                BlendMode.srcIn,
              ),
            ),
            iconBgColor: const Color(0xFFeef7fc),
            title: 'Telegram',
            subtitle: '@Duu1at',
            onTap: () {},
          ),
          const Divider(),

          _ContactItem(
            icon: Assets.icons.email.svg(
              width: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFFd97706),
                BlendMode.srcIn,
              ),
            ),
            iconBgColor: const Color(0xFFfdf3c7),
            title: 'Email',
            subtitle: 'dbolsunbekuulu@gmail.com',
            onTap: () {},
          ),
          const Divider(),

          _ContactItem(
            icon: Assets.icons.call.svg(
              width: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFF65a30d),
                BlendMode.srcIn,
              ),
            ),
            iconBgColor: const Color(0xFFecfccb),
            title: l10n.authContactCallLabel,
            subtitle: '+996 702 31-36-11',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final SvgPicture icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.cardBorderRadius,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x2),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: AppRadius.cardBorderRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x3),
                child: icon,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
