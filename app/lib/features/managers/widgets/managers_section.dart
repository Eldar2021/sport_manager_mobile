import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:managers/managers.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/managers/managers.dart';

class ManagersSection extends StatelessWidget {
  const ManagersSection({
    required this.cubit,
    required this.onDelete,
    super.key,
  });

  final ManagersCubit cubit;
  final ValueChanged<ManagerModel> onDelete;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagersCubit, ManagersState>(
      bloc: cubit,
      buildWhen: (a, b) => a.managers != b.managers || a.deletingId != b.deletingId,
      builder: (_, state) {
        return switch (state.managers) {
          RequestInitial<List<ManagerModel>>() || RequestLoading<List<ManagerModel>>() => const Card(
            margin: EdgeInsets.zero,
            child: ManagersListSkeleton(),
          ),
          RequestFailure<List<ManagerModel>>(:final exception) => ErrorBodyWidget(
            exception,
            onRetryPressed: cubit.loadManagers,
          ),
          RequestSuccess<List<ManagerModel>>(:final data) when data.isEmpty => const Card(
            margin: EdgeInsets.zero,
            child: ManagersEmpty(),
          ),
          RequestSuccess<List<ManagerModel>>(:final data) => Card(
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < data.length; i++) ...[
                  if (i != 0) const Divider(height: 1),
                  ManagerCard(
                    key: ValueKey(data[i].id),
                    manager: data[i],
                    isDeleting: state.deletingId == data[i].id,
                    onDelete: () => onDelete(data[i]),
                  ),
                ],
              ],
            ),
          ),
        };
      },
    );
  }
}
