import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/tables/tables.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ToPayTile extends StatelessWidget {
  const ToPayTile(this.currency, {super.key});

  final String currency;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionActiveCubit, SessionActiveState, int>(
      selector: (s) {
        final subtotal = s.currentAmount;
        return subtotal - (subtotal * s.effectiveDiscount / 100).round();
      },
      builder: (context, toPay) => ListTile(
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
    );
  }
}
