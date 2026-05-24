import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:product/product.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/features/spots/spots.dart';
import 'package:sport_manager_mobile/l10n/l10n.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class AddProductSheet extends StatefulWidget {
  const AddProductSheet(this.currency, {super.key});

  final String currency;

  static Future<void> show(
    BuildContext context, {
    required String currency,
    required SessionActiveCubit sessionCubit,
  }) {
    return showModalBottomSheet<void>(
      backgroundColor: context.colors.surface,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sessionCubit),
        ],
        child: AddProductSheet(currency),
      ),
    );
  }

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  late final AddProductSheetCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = AddProductSheetCubit(GetIt.I<ProductRepository>());
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => _AddProductSheetBody(
          scrollController: controller,
          currency: widget.currency,
        ),
      ),
    );
  }
}

class _AddProductSheetBody extends StatelessWidget {
  const _AddProductSheetBody({
    required this.scrollController,
    required this.currency,
  });

  final ScrollController scrollController;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.addProductSheetTitle,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
        const CategoryChips(),
        Expanded(
          child: BlocBuilder<AddProductSheetCubit, AddProductSheetState>(
            buildWhen: (a, b) => a.products != b.products,
            builder: (_, state) => switch (state.products) {
              DataInitial() || DataLoading() => ProductGridShimmer(scrollController),
              DataFailure(:final exception) => ErrorBodyWidget(
                exception,
                onRetryPressed: () => context.read<AddProductSheetCubit>().load(),
              ),
              DataSuccess(:final data) when data.isEmpty => Center(
                child: Text(context.l10n.productsEmptyTitle),
              ),
              DataSuccess(:final data) => GridView.builder(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x4,
                  AppSpacing.x2,
                  AppSpacing.x4,
                  AppSpacing.x4,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.x3,
                  mainAxisSpacing: AppSpacing.x3,
                  childAspectRatio: 1.2,
                ),
                itemCount: data.length,
                itemBuilder: (_, i) {
                  return AddProductGridItem(
                    data[i],
                    currency: currency,
                    onTap: () {
                      AddProductQuantityDialog.show(
                        context,
                        product: data[i],
                        currency: currency,
                      );
                    },
                  );
                },
              ),
            },
          ),
        ),
      ],
    );
  }
}
