import 'package:core/core.dart';
import 'package:facility/facility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/features/venues/venues.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

/// All spots of the currently-selected venue, sorted by revenue desc.
/// Tap → spot detail.
class SpotsSection extends StatelessWidget {
  const SpotsSection({
    required this.cubit,
    required this.venueType,
    super.key,
  });

  final ReportOverviewCubit cubit;
  final VenueType venueType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          venueType.spotLabelPlural(context),
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.x2),
        BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
          bloc: cubit,
          buildWhen: (a, b) => a.spots != b.spots,
          builder: (_, state) => switch (state.spots) {
            RequestInitial<List<SpotReportRowModel>>() ||
            RequestLoading<List<SpotReportRowModel>>() => const SpotsSkeleton(),
            RequestFailure<List<SpotReportRowModel>>() => _MessageCard(l10n.reportsErrorTitle),
            RequestSuccess<List<SpotReportRowModel>>(:final data) when data.isEmpty => _MessageCard(
              l10n.reportsEmptySubtitle,
            ),
            RequestSuccess<List<SpotReportRowModel>>(:final data) => _SpotsCard(
              data,
              spotLabel: venueType.spotLabel(context),
            ),
          },
        ),
      ],
    );
  }
}

class _SpotsCard extends StatelessWidget {
  const _SpotsCard(this.data, {required this.spotLabel});

  final List<SpotReportRowModel> data;
  final String spotLabel;

  @override
  Widget build(BuildContext context) {
    final maxRevenue = data.first.revenue == 0 ? 1 : data.first.revenue;
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < data.length; i++) ...[
            if (i != 0) const Divider(height: 1),
            SpotsRow(row: data[i], maxRevenue: maxRevenue, spotLabel: spotLabel),
          ],
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Center(child: Text(message)),
      ),
    );
  }
}
