import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class UserProfileExtraData extends StatelessWidget {
  const UserProfileExtraData(this.data, {super.key});

  final ProfileModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.x6),
        Text(
          'Аккаунт',
          style: context.appTextStyles.disabled.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.x2),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (data.subscriptionEndDate != null)
                ProfileItemTile(
                  title: 'Подписка',
                  subtitle: 'Активна · до ${_getSubscriptionDate(context)}',
                  iconBgColor: context.colors.primary.withValues(alpha: 0.1),
                  icon: Icon(
                    Icons.credit_card,
                    color: context.colors.primary,
                  ),
                  onTap: () {},
                ),
              if (data.subscriptionEndDate != null) const Divider(),
              ProfileItemTile(
                title: 'Сменить пароль',
                iconBgColor: context.colors.inverseSurface.withValues(alpha: 0.1),
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

  String? _getSubscriptionDate(BuildContext context) {
    final locale = Localizations.localeOf(context);
    if (data.subscriptionEndDate != null) {
      return DateFormat('d MMMM yyyy', locale.languageCode).format(data.subscriptionEndDate!);
    }
    return null;
  }
}
