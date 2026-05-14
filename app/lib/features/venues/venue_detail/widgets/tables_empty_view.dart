import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/features/auth/auth.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TablesEmptyView extends StatelessWidget {
  const TablesEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.table_restaurant_outlined,
            color: context.colors.onSurfaceVariant,
            size: AppSpacing.x10,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            context.l10n.homeTablesEmpty,
            style: context.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x1),
          BlocSelector<AuthCubit, AuthState, bool>(
            selector: (state) => state.isManager,
            builder: (context, isManager) => Text(
              isManager ? context.l10n.homeTablesEmptySubManager : context.l10n.homeTablesEmptySub,
              style: context.appTextStyles.muted.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
