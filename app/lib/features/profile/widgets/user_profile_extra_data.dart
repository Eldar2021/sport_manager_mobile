import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class UserProfileExtraData extends StatelessWidget {
  const UserProfileExtraData(this.data, {super.key});

  final ProfileModel data;

  @override
  Widget build(BuildContext context) {
    final subscriptionEndDate = data.subscriptionEndDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.x6),
        Text(
          context.l10n.profileSectionAccount,
          style: context.appTextStyles.disabled.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.x2),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (subscriptionEndDate != null) ...[
                ProfileItemTile(
                  title: context.l10n.profileSubscriptionTitle,
                  subtitle: context.l10n.profileSubscriptionActiveUntil(_formatDate(context, subscriptionEndDate)),
                  iconBgColor: context.colors.primary.withValues(alpha: AppOpacity.tint),
                  icon: Icon(
                    Icons.credit_card,
                    color: context.colors.primary,
                  ),
                  onTap: () {},
                ),
                const Divider(),
              ],
              ProfileItemTile(
                title: context.l10n.profileChangePasswordTitle,
                iconBgColor: context.colors.inverseSurface.withValues(alpha: AppOpacity.tint),
                icon: Icon(
                  Icons.lock_outline,
                  color: context.colors.shadow,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context);
    return DateFormat('d MMMM yyyy', locale.languageCode).format(date);
  }
}
