import 'package:flutter/material.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

typedef ItemTitleBuilder<T> = String Function(BuildContext context, T item);

typedef SheetItemBuilder<T> =
    Widget Function(
      BuildContext context,
      T item,
      bool isSelected,
      VoidCallback onTap,
    );

class CustomSheetItemList<T> extends StatelessWidget {
  const CustomSheetItemList({
    required this.items,
    required this.titleBuilder,
    required this.controller,
    required this.emptyMessage,
    this.subtitleBuilder,
    this.selectedItem,
    this.itemBuilder,
    this.separator,
    super.key,
  });

  final List<T> items;
  final ItemTitleBuilder<T> titleBuilder;
  final ItemTitleBuilder<T>? subtitleBuilder;
  final ScrollController controller;
  final T? selectedItem;
  final String emptyMessage;
  final SheetItemBuilder<T>? itemBuilder;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final bottomInset = AppSpacing.x10 + keyboardHeight;

    if (items.isEmpty) {
      return SingleChildScrollView(
        controller: controller,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: _CustomSheetEmpty(emptyMessage),
      );
    }

    final builder = itemBuilder;
    if (builder != null) {
      return ListView.separated(
        controller: controller,
        padding: EdgeInsets.fromLTRB(AppSpacing.x4, 0, AppSpacing.x4, bottomInset),
        itemCount: items.length,
        separatorBuilder: (_, _) => separator ?? const SizedBox(height: AppSpacing.x2),
        itemBuilder: (ctx, i) {
          final item = items[i];
          return builder(
            ctx,
            item,
            selectedItem == item,
            () => Navigator.of(ctx).pop(item),
          );
        },
      );
    }

    return SingleChildScrollView(
      controller: controller,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surfaceContainer,
            borderRadius: AppRadius.cardBorderRadius,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                minVerticalPadding: 0,
                visualDensity: const VisualDensity(vertical: -4),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x4,
                  vertical: AppSpacing.x1,
                ),
                title: Text(titleBuilder(context, item)),
                titleTextStyle: context.textTheme.titleMedium,
                subtitle: subtitleBuilder != null ? Text(subtitleBuilder!(context, item)) : null,
                subtitleTextStyle: context.textTheme.bodyMedium,
                trailing: _SelectionIndicator(isSelected: selectedItem == item),
                onTap: () => Navigator.of(context).pop(item),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (!isSelected) {
      return SizedBox.square(
        dimension: 22,
        child: Center(
          child: SizedBox.square(
            dimension: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.outlineVariant, width: 2),
              ),
            ),
          ),
        ),
      );
    }
    return SizedBox.square(
      dimension: 22,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SizedBox.square(
            dimension: 9,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.onPrimary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomSheetEmpty extends StatelessWidget {
  const _CustomSheetEmpty(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: AppSpacing.x12,
            color: context.colors.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.appTextStyles.muted.bodyMedium,
          ),
        ],
      ),
    );
  }
}
