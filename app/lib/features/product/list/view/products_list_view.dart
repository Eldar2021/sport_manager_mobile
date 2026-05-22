import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/app/app.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/product/product.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class ProductsListView extends StatefulWidget {
  const ProductsListView({super.key});

  @override
  State<ProductsListView> createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView> {
  late final ProductsListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ProductsListCubit(GetIt.I<ProductRepository>());
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _onDelete(ProductModel product) {
    return AppDestructiveSheet.show(
      context,
      icon: Icons.inventory_2_outlined,
      title: context.l10n.productsDeleteTitle(product.name),
      subtitle: context.l10n.productsDeleteSubtitle,
      confirmLabel: context.l10n.menuDelete,
      onConfirm: () async {
        try {
          await _cubit.delete(product.id);
        } on Object catch (e) {
          if (mounted) context.handleError(e);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppButtonScope(
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.productsTitle)),
        body: Column(
          children: [
            CategoryFilterBar(_cubit),
            Expanded(
              child: RefreshIndicator.adaptive(
                onRefresh: _cubit.load,
                child: BlocBuilder<ProductsListCubit, ProductsListState>(
                  bloc: _cubit,
                  buildWhen: (a, b) => a.products != b.products || a.deletingId != b.deletingId,
                  builder: (context, state) {
                    return switch (state.products) {
                      RequestInitial<List<ProductModel>>() ||
                      RequestLoading<List<ProductModel>>() => const ProductsListSkeleton(),
                      RequestFailure<List<ProductModel>>(:final exception) => ErrorBodyWidget(
                        exception,
                        onRetryPressed: _cubit.load,
                      ),
                      RequestSuccess<List<ProductModel>>(:final data) when data.isEmpty => const ProductsEmptyView(),
                      RequestSuccess<List<ProductModel>>(:final data) => ProductsListCard(
                        data: data,
                        deletingId: state.deletingId,
                        onEdit: (p) => _navProductForm(),
                        onDelete: _onDelete,
                      ),
                    };
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: kAppButtonFabLocation,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: AppButton(
            onPressed: _navProductForm,
            child: Text(context.l10n.productsAddButton),
          ),
        ),
      ),
    );
  }

  Future<void> _navProductForm() async {
    final result = await context.push<ProductModel>(AppRoutes.productForm);
    if (result != null) await _cubit.load();
  }
}
