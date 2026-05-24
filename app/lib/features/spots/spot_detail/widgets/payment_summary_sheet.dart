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
          _ProductsBreakdown(currency: currency),
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

class _ProductsBreakdown extends StatelessWidget {
  const _ProductsBreakdown({required this.currency});

  final String currency;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionActiveCubit, SessionActiveState, (List<SessionProductItemModel>, int, int)>(
      selector: (s) => (s.session.products, s.session.productsAmount, s.currentAmount),
      builder: (context, data) {
        final (products, productsAmount, subtotal) = data;
        if (products.isEmpty) return const SizedBox.shrink();
        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.outlineVariant,
            borderRadius: AppRadius.buttonBorderRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.x2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
                  child: Text(
                    context.l10n.paymentProductsSection(products.length),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                for (final item in products)
                  _PaymentProductRow(item: item, currency: currency),
                const SizedBox(height: AppSpacing.x2),
                Divider(color: context.colors.outline, height: 1),
                const SizedBox(height: AppSpacing.x2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
                  child: SpotInfoRow(
                    label: context.l10n.paymentProductsTotal,
                    value: '$productsAmount $currency',
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Divider(color: context.colors.outline, height: 1),
                const SizedBox(height: AppSpacing.x2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
                  child: SpotInfoRow(
                    label: context.l10n.paymentSubtotalLine,
                    value: '$subtotal $currency',
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PaymentProductRow extends StatelessWidget {
  const _PaymentProductRow({required this.item, required this.currency});

  final SessionProductItemModel item;
  final String currency;

  String _unitShort(AppLocalizations l10n) {
    return switch (item.unitSnapshot) {
      'KG' => l10n.productUnitKgShort,
      'LITRE' => l10n.productUnitLitreShort,
      'PORTION' => l10n.productUnitPortionShort,
      'HOUR' => l10n.productUnitHourShort,
      _ => l10n.productUnitPieceShort,
    };
  }

  @override
  Widget build(BuildContext context) {
    final unitShort = _unitShort(context.l10n);
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
      leading: _PaymentProductIcon(categorySnapshot: item.categorySnapshot),
      title: Text(
        item.nameSnapshot,
        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '1 $unitShort × ${item.priceSnapshot} $currency',
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
      trailing: Text(
        '${item.priceSnapshot} $currency',
        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _PaymentProductIcon extends StatelessWidget {
  const _PaymentProductIcon({required this.categorySnapshot});

  final String categorySnapshot;

  @override
  Widget build(BuildContext context) {
    final icon = switch (categorySnapshot) {
      'DRINK' => Icons.local_drink_outlined,
      'FOOD' => Icons.restaurant_outlined,
      'EQUIPMENT' => Icons.sports_tennis_outlined,
      _ => Icons.shopping_bag_outlined,
    };
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.x1),
      ),
      child: Icon(icon, size: 16, color: context.colors.onSurfaceVariant),
    );
  }
}
