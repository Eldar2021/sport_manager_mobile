import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class TopProductsSection extends StatelessWidget {
  const TopProductsSection(this.cubit, {super.key});

  final ReportOverviewCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.reportsTopProductsTitle,
                style: context.textTheme.titleMedium,
              ),
            ),
            BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
              bloc: cubit,
              buildWhen: (a, b) => a.products != b.products || a.filter != b.filter,
              builder: (_, state) {
                final venueId = state.filter.venueId;
                if (venueId == null) return const SizedBox.shrink();
                if (state.products is! RequestSuccess<ProductReportSummaryModel>) return const SizedBox.shrink();
                return TextButton(
                  onPressed: () => context.push('/reports/venue/$venueId/products', extra: state.filter.period),
                  child: Text(context.l10n.reportsSeeAll),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        BlocBuilder<ReportOverviewCubit, ReportOverviewState>(
          bloc: cubit,
          buildWhen: (a, b) => a.products != b.products || a.filter.venueId != b.filter.venueId,
          builder: (_, state) => switch (state.products) {
            RequestInitial<ProductReportSummaryModel>() ||
            RequestLoading<ProductReportSummaryModel>() => const ProductsTopSkeleton(),
            RequestFailure<ProductReportSummaryModel>() => _MessageCard(context.l10n.reportsErrorTitle),
            RequestSuccess<ProductReportSummaryModel>(:final data) when data.items.isEmpty => _MessageCard(
              context.l10n.reportsEmptySubtitle,
            ),
            RequestSuccess<ProductReportSummaryModel>(:final data) => ProductsTopList(
              items: data.items.take(5).toList(),
              venueId: state.filter.venueId ?? '',
            ),
          },
        ),
      ],
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
