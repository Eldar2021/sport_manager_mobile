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

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({
    required this.venueId,
    required this.productId,
    super.key,
  });

  final String venueId;
  final String productId;

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> with SingleTickerProviderStateMixin {
  late final ProductDetailCubit _cubit;
  late final TabController _tabController;

  static const List<ReportPeriod> _periods = ReportPeriodTabs.periods;

  @override
  void initState() {
    super.initState();
    _cubit = ProductDetailCubit(
      repository: GetIt.I<ProductRepository>(),
      venueId: widget.venueId,
      productId: widget.productId,
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
        title: Text(context.l10n.reportsProductDetailTitle),
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
              (_) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.x4,
                    0,
                    AppSpacing.x4,
                    AppSpacing.x6,
                  ),
                  children: [
                    BlocBuilder<ProductDetailCubit, ProductDetailState>(
                      bloc: _cubit,
                      buildWhen: (a, b) => a.detail != b.detail || a.filter.period != b.filter.period,
                      builder: (_, state) {
                        return switch (state.detail) {
                          RequestInitial<ProductSalesSummaryModel>() ||
                          RequestLoading<ProductSalesSummaryModel>() => const ProductDetailSkeleton(),
                          RequestFailure<ProductSalesSummaryModel>(:final exception) => ErrorBodyWidget(
                            exception,
                            onRetryPressed: _cubit.load,
                          ),
                          RequestSuccess<ProductSalesSummaryModel>(:final data) => ProductBody(data),
                        };
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
