import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class PaymentSummarySheet extends StatelessWidget {
  const PaymentSummarySheet(this.table, {super.key});

  final TableModel table;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionActiveCubit, SessionActiveState>(
      listenWhen: (prev, curr) => prev.stopStatus != curr.stopStatus,
      listener: (context, state) {
        if (state.stopStatus.isSuccess) {
          Navigator.of(context).pop();
        } else if (state.stopStatus.isFailure) {
          final exc = (state.stopStatus as RequestFailure<SessionModel>).exception;
          context.handleError(exc);
        }
      },
      builder: (context, state) {
        final cubit = context.read<SessionActiveCubit>();
        final session = state.session;
        final currency = table.currency.localizedName(context.l10n);
        final subtotal = state.currentAmount;
        final discount = state.effectiveDiscount;
        final toPay = subtotal - (subtotal * discount / 100).round();
        final tarif = session.tarifAmountSnapshot ?? 0;
        final startStr = DateFormat('HH:mm').format(session.startedAt);
        final endStr = DateFormat('HH:mm').format(DateTime.now());
        final tableName = table.name ?? context.l10n.homeTableTitle(table.number);
        final tag = table.description;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.x6,
            AppSpacing.x4,
            AppSpacing.x6,
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
                    context.l10n.tableDetailPaymentTitle,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                tag != null && tag.isNotEmpty ? '$tableName · «$tag»' : tableName,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$startStr → $endStr',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: AppRadius.buttonBorderRadius,
                  color: context.colors.outlineVariant,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.x2),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.x2),
                      TableInfoRow(
                        label: context.l10n.tableDetailDuration,
                        value: context.l10n.tableDetailDurationMin(
                          state.elapsed.inMinutes,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      TableInfoRow(
                        label: context.l10n.tableDetailTariff,
                        value: '$tarif $currency',
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Divider(
                        color: context.colors.outline,
                        height: 1,
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      TableInfoRow(
                        label: context.l10n.tableDetailSubtotal,
                        value: '$subtotal $currency',
                      ),
                      const SizedBox(height: AppSpacing.x4),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),

              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x3,
                  vertical: AppSpacing.x2,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.buttonBorderRadius,
                ),
                tileColor: context.colors.primary,
                title: Text(
                  context.l10n.tableDetailToPay,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.onPrimary,
                  ),
                ),
                trailing: Text(
                  '$toPay ${currency.toLowerCase()}',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colors.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              AppButton(
                onPressed: state.stopStatus.isLoading ? null : cubit.confirmStop,
                isLoading: state.stopStatus.isLoading,
                child: Text(context.l10n.tableDetailConfirmAndClose),
              ),
              const SizedBox(height: AppSpacing.x4),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(context.l10n.cancel),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
