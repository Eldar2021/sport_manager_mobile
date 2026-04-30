import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/features/profile/profile.dart';
import 'package:sport_manager_mobile/features/subscription/subscription.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';
import 'package:subscription/subscription.dart';

class UserProfileExtraData extends StatelessWidget {
  const UserProfileExtraData(this.data, {super.key});

  final ProfileModel data;

  @override
  Widget build(BuildContext context) {
    final isOwner = data.user.role == UserRole.owner;
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
              if (isOwner) ...[
                _SubscriptionTile(data.subscriptionEndDate),
                const Divider(),
              ],
              ProfileItemTile(
                title: context.l10n.profileChangePasswordTitle,
                iconBgColor: context.colors.inverseSurface.withValues(
                  alpha: AppOpacity.tint,
                ),
                icon: Icon(
                  Icons.lock_outline,
                  color: context.colors.shadow,
                ),
                onTap: () => context.push(AppRoutes.updatePassword),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubscriptionTile extends StatelessWidget {
  const _SubscriptionTile(this.fallbackEndDate);

  final DateTime? fallbackEndDate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      buildWhen: (a, b) => a.summary != b.summary,
      builder: (context, state) {
        final color = _color(context, state.alert);
        return ProfileItemTile(
          title: context.l10n.profileSubscriptionTitle,
          subtitle: _subtitle(context, state.data),
          iconBgColor: color.withValues(alpha: AppOpacity.tint),
          icon: Icon(Icons.credit_card, color: color),
          onTap: () => context.push(AppRoutes.subscription),
        );
      },
    );
  }

  Color _color(BuildContext context, SubscriptionAlert alert) => switch (alert) {
    SubscriptionAlert.expired => context.colors.error,
    SubscriptionAlert.grace || SubscriptionAlert.warning => context.appColors.warning,
    SubscriptionAlert.none => context.colors.primary,
  };

  String _subtitle(BuildContext context, SubscriptionSummaryModel? s) {
    if (s == null) {
      return fallbackEndDate == null
          ? context.l10n.subscriptionStatusActive
          : context.l10n.profileSubscriptionActiveUntil(
              _formatDate(context, fallbackEndDate!),
            );
    }
    return switch (s.alert) {
      SubscriptionAlert.expired => context.l10n.profileSubscriptionExpired,
      SubscriptionAlert.grace => context.l10n.profileSubscriptionGrace(s.graceDaysRemaining),
      SubscriptionAlert.warning => context.l10n.profileSubscriptionExpiresIn(s.daysUntilExpiry),
      SubscriptionAlert.none => context.l10n.profileSubscriptionActiveUntil(_formatDate(context, s.endDate)),
    };
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('d MMMM yyyy', locale).format(date.toLocal());
  }
}
