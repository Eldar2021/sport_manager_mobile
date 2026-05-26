import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class PaymentSummarySheet extends StatelessWidget {
  const PaymentSummarySheet(this.spot, {required this.venueType, super.key});

  final SpotModel spot;
  final VenueType venueType;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SessionActiveCubit>();
    final session = cubit.state.session;
    final currency = spot.currency.localizedName(context.l10n);
    final spotName = spot.name ?? context.l10n.homeSpotTitle(venueType.spotLabel(context), spot.number);
    final timeRange =
        '${DateFormat('HH:mm').format(session.startedAt)} → ${DateFormat('HH:mm').format(DateTime.now())}';
    final tag = spot.description;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.bottom(context) + AppSpacing.x4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.spotDetailPaymentTitle,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.close_rounded),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            tag != null && tag.isNotEmpty ? '$spotName · «$tag»' : spotName,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            timeRange,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          SummaryCard(
            tarif: session.tarifAmountSnapshot ?? 0,
            currency: currency,
          ),
          const SizedBox(height: AppSpacing.x4),
          ToPayTile(currency),
          const SizedBox(height: AppSpacing.x3),
          BlocConsumer<SessionActiveCubit, SessionActiveState>(
            listenWhen: (prev, curr) => prev.stopStatus != curr.stopStatus,
            listener: (context, state) {
              if (state.stopStatus.isSuccess) {
                Navigator.of(context).pop();
              } else if (state.stopStatus.isFailure) {
                final exception = (state.stopStatus as RequestFailure<SessionModel>).exception;
                context.handleError(exception);
              }
            },
            builder: (context, state) {
              return AppButton(
                onPressed: cubit.confirmStop,
                isLoading: state.stopStatus.isLoading,
                child: Text(context.l10n.spotDetailConfirmAndClose),
              );
            },
          ),
          const SizedBox(height: AppSpacing.x4),
          Center(
            child: TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(context.l10n.cancel),
            ),
          ),
        ],
      ),
    );
  }
}
