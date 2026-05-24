import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:product/product.dart';
import 'package:reports/reports.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/report/report.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({
    required this.venueId,
    this.initialPeriod = ReportPeriod.month,
    super.key,
  });

  final String venueId;
  final ReportPeriod initialPeriod;

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> with SingleTickerProviderStateMixin {
  late final ProductsCubit _cubit;
  late final TabController _tabController;

  static const List<ReportPeriod> _periods = ReportPeriodTabs.periods;

  @override
  void initState() {
    super.initState();
    _cubit = ProductsCubit(
      repository: GetIt.I<ProductRepository>(),
      venueId: widget.venueId,
      initialPeriod: widget.initialPeriod,
    );
    _tabController = TabController(
      length: _periods.length,
      vsync: this,
      initialIndex: _periods.indexOf(_cubit.state.filter.period),
    );
    _tabController.addListener(_onTabChanged);
    _cubit.load();
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    _cubit.close();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    _cubit.changePeriod(_periods[_tabController.index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.reportsProductsTitle),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _cubit.load,
        child: NestedScrollView(
          headerSliverBuilder: (_, _) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.x3),
                  ReportPeriodTabs(_tabController),
                  const SizedBox(height: AppSpacing.x3),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: List.generate(
              _periods.length,
              (_) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x4,
                  0,
                  AppSpacing.x4,
                  AppSpacing.x6,
                ),
                children: [
                  BlocBuilder<ProductsCubit, ProductsState>(
                    bloc: _cubit,
                    buildWhen: (a, b) => a.products != b.products,
                    builder: (_, state) => switch (state.products) {
                      RequestInitial<ProductReportSummaryModel>() ||
                      RequestLoading<ProductReportSummaryModel>() => const ProductsSkeleton(),
                      RequestFailure<ProductReportSummaryModel>(:final exception) => ErrorBodyWidget(
                        exception,
                        onRetryPressed: _cubit.load,
                      ),
                      RequestSuccess<ProductReportSummaryModel>(:final data) when data.items.isEmpty => _EmptyCard(
                        context.l10n.reportsEmptySubtitle,
                      ),
                      RequestSuccess<ProductReportSummaryModel>(:final data) => ProductsList(
                        items: data.items,
                        venueId: widget.venueId,
                      ),
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
