import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/generated/assets.gen.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

const Color _whatsappBrand = Color(0xFF41D365);
const Color _telegramBrand = Color(0xFF369ED9);

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
    final config = GetIt.I<RemoteConfigRepository>();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x4,
        0,
        AppSpacing.x4,
        AppSpacing.x6 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.contactSupportTitle,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            l10n.contactSupportSubtitle,
            style: context.appTextStyles.muted.bodySmall,
          ),
          const SizedBox(height: AppSpacing.x4),
          const Divider(),
          _ContactItem(
            iconAsset: Assets.icons.whatsapp,
            iconColor: _whatsappBrand,
            title: 'WhatsApp',
            subtitle: config.get(AppConfigEntries.whatsappPhone),
            onTap: () {},
          ),
          const Divider(),
          _ContactItem(
            iconAsset: Assets.icons.telegram,
            iconColor: _telegramBrand,
            title: 'Telegram',
            subtitle: config.get(AppConfigEntries.telegramHandle),
            onTap: () {},
          ),
          const Divider(),
          _ContactItem(
            iconAsset: Assets.icons.email,
            iconColor: context.colors.primary,
            title: 'Email',
            subtitle: config.get(AppConfigEntries.supportEmail),
            onTap: () {},
          ),
          const Divider(),
          _ContactItem(
            iconAsset: Assets.icons.call,
            iconColor: context.appColors.success,
            title: l10n.contactCallLabel,
            subtitle: config.get(AppConfigEntries.callPhone),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem({
    required this.iconAsset,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final SvgGenImage iconAsset;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: AppOpacity.tint),
          borderRadius: AppRadius.cardBorderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x3),
          child: iconAsset.svg(
            width: 24,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
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
    );
  }
}
