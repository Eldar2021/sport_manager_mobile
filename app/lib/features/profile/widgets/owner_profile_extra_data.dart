import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class OwnerProfileExtraData extends StatelessWidget {
  const OwnerProfileExtraData(this.data, {super.key});

  final ProfileModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.x6),
        Text(
          'Управление',
          style: context.appTextStyles.disabled.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.x2),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileItemTile(
                title: 'Управление залами',
                subtitle: '${data.venuesCount} залов',
                iconBgColor: context.colors.primary.withValues(alpha: 0.1),
                icon: Icon(
                  Icons.location_on,
                  color: context.colors.primary,
                ),
                onTap: () {},
              ),
              const Divider(),
              ProfileItemTile(
                title: 'Менеджеры',
                subtitle: '${data.managersCount} менеджеров',
                iconBgColor: context.appColors.successContainer,
                icon: Icon(
                  Icons.group,
                  color: context.appColors.success,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
