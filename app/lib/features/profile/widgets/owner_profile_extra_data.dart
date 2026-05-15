import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class OwnerProfileExtraData extends StatelessWidget {
  const OwnerProfileExtraData(this.data, {super.key});

  final ProfileModel data;

  @override
  Widget build(BuildContext context) {
    final venuesCount = data.profileData?.venuesCount ?? 0;
    final managersCount = data.profileData?.managersCount ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.x6),
        Text(
          context.l10n.profileSectionManagement,
          style: context.appTextStyles.disabled.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.x2),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileItemTile(
                title: context.l10n.profileManageVenuesTitle,
                subtitle: context.l10n.profileManageVenuesSubtitle(venuesCount),
                iconBgColor: context.colors.primary.withValues(alpha: AppOpacity.tint),
                icon: Icon(
                  Icons.location_on,
                  color: context.colors.primary,
                ),
                onTap: () => context.push(AppRoutes.venuesList),
              ),
              const Divider(),
              ProfileItemTile(
                title: context.l10n.profileManagersTitle,
                subtitle: context.l10n.profileManagersSubtitle(managersCount),
                iconBgColor: context.appColors.successContainer,
                icon: Icon(
                  Icons.group,
                  color: context.appColors.success,
                ),
                onTap: () => context.push(AppRoutes.managers),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
