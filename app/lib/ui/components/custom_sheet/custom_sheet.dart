import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_manager_mobile/core/core.dart';
import 'package:sport_manager_mobile/ui/ui.dart';

class CustomSheet<T> extends StatefulWidget {
  const CustomSheet({
    required this.title,
    required this.loader,
    required this.titleBuilder,
    required this.emptyMessage,
    this.subtitleBuilder,
    this.selectedItem,
    this.searchFilter,
    this.searchHint,
    this.initialSize = 0.4,
    this.itemBuilder,
    this.separator,
    this.footer,
    this.footerHeight = 0,
    super.key,
  });

  final String title;
  final Future<List<T>> Function() loader;
  final ItemTitleBuilder<T> titleBuilder;
  final ItemTitleBuilder<T>? subtitleBuilder;
  final T? selectedItem;
  final double initialSize;
  final SheetItemFilter<T>? searchFilter;
  final String? searchHint;
  final String emptyMessage;
  final SheetItemBuilder<T>? itemBuilder;
  final Widget? separator;
  final Widget? footer;

  /// Footer height in logical pixels — used only by the auto-fit size
  /// calculation. Pass the rendered height of [footer] (button + paddings +
  /// safe area) so the list does not get hidden behind it.
  final double footerHeight;

  static Future<T?> open<T>({
    required BuildContext context,
    required String title,
    required Future<List<T>> Function() loader,
    required ItemTitleBuilder<T> titleBuilder,
    required String emptyMessage,
    ItemTitleBuilder<T>? subtitleBuilder,
    T? selectedItem,
    double initialSize = 0.4,
    SheetItemFilter<T>? searchFilter,
    String? searchHint,
    SheetItemBuilder<T>? itemBuilder,
    Widget? separator,
    Widget? footer,
    double footerHeight = 0,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => CustomSheet<T>(
        title: title,
        loader: loader,
        titleBuilder: titleBuilder,
        subtitleBuilder: subtitleBuilder,
        selectedItem: selectedItem,
        initialSize: initialSize,
        searchFilter: searchFilter,
        searchHint: searchHint,
        emptyMessage: emptyMessage,
        itemBuilder: itemBuilder,
        separator: separator,
        footer: footer,
        footerHeight: footerHeight,
      ),
    );
  }

  @override
  State<CustomSheet<T>> createState() => _CustomSheetState<T>();
}

class _CustomSheetState<T> extends State<CustomSheet<T>> {
  static const _baseMinSize = 0.15;
  static const _absoluteMax = 0.92;
  static const _headerBase = 92.0;
  static const _searchHeight = 56.0;
  static const _itemHeight = 56.0;
  static const _bottomPadding = 40.0;
  static const _emptyStateHeight = 144.0;
  static const _animDuration = Duration(milliseconds: 300);

  final _sheetController = DraggableScrollableController();
  final _searchController = TextEditingController();
  late final CustomSheetCubit<T> _cubit;

  double _maxSize = _absoluteMax;
  bool _maxSizeLocked = false;
  double _prevKeyboardHeight = 0;
  bool _isDismissing = false;

  bool get _hasSearch => widget.searchFilter != null;

  double get _fixedChrome => _headerBase + (_hasSearch ? _searchHeight : 0) + widget.footerHeight;

  double get _keyboardFraction {
    final screenHeight = MediaQuery.sizeOf(context).height;
    if (screenHeight == 0) return 0;
    return MediaQuery.viewInsetsOf(context).bottom / screenHeight;
  }

  @override
  void initState() {
    super.initState();
    _cubit = CustomSheetCubit<T>(
      loader: widget.loader,
      searchFilter: widget.searchFilter,
    )..load();
    _sheetController.addListener(_dismissIfBehindKeyboard);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    if (_prevKeyboardHeight == keyboardHeight) return;
    _prevKeyboardHeight = keyboardHeight;
    if (_cubit.state.status is DataSuccess) _animateForCurrentContent();
  }

  @override
  void dispose() {
    _sheetController
      ..removeListener(_dismissIfBehindKeyboard)
      ..dispose();
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _dismissIfBehindKeyboard() {
    if (_isDismissing || !mounted || !_sheetController.isAttached) return;
    if (_keyboardFraction == 0) return;
    if (_sheetController.size <= _keyboardFraction) {
      _isDismissing = true;
      Navigator.of(context).pop();
    }
  }

  double _calculateTargetSize(int itemCount) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final content = itemCount > 0 ? itemCount * _itemHeight : _emptyStateHeight;
    final baseFraction = (_fixedChrome + content + _bottomPadding) / screenHeight;
    return (baseFraction + _keyboardFraction).clamp(_baseMinSize, _absoluteMax);
  }

  void _animateForCurrentContent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_sheetController.isAttached) return;
      final target = _calculateTargetSize(_cubit.state.filteredItems.length);
      final effectiveMax = (_maxSize + _keyboardFraction).clamp(0.0, 1.0);
      _sheetController.jumpTo(target.clamp(_baseMinSize, effectiveMax));
    });
  }

  void _onContentChanged({required int filteredCount, required int totalCount}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_sheetController.isAttached) return;
      final target = _calculateTargetSize(filteredCount);
      final effectiveMax = (_maxSize + _keyboardFraction).clamp(0.0, 1.0);
      _sheetController
          .animateTo(
            target.clamp(_baseMinSize, effectiveMax),
            duration: _animDuration,
            curve: Curves.easeInOut,
          )
          .whenComplete(() => _lockMaxSize(totalCount));
    });
  }

  void _lockMaxSize(int totalCount) {
    if (!mounted || _maxSizeLocked) return;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final content = totalCount * _itemHeight + _bottomPadding;
    final maxTarget = ((_fixedChrome + content) / screenHeight).clamp(_baseMinSize, _absoluteMax);
    setState(() {
      _maxSize = (maxTarget + 0.05).clamp(0.3, _absoluteMax);
      _maxSizeLocked = true;
    });
  }

  void _retry() {
    setState(() {
      _maxSize = _absoluteMax;
      _maxSizeLocked = false;
    });
    if (_sheetController.isAttached) {
      _sheetController.animateTo(
        widget.initialSize.clamp(_baseMinSize, _maxSize),
        duration: _animDuration,
        curve: Curves.easeInOut,
      );
    }
    _cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveMax = (_maxSize + _keyboardFraction).clamp(_baseMinSize, 1.0);
    final effectiveInitial = widget.initialSize.clamp(_baseMinSize, effectiveMax);

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: effectiveInitial,
      minChildSize: _baseMinSize,
      maxChildSize: effectiveMax,
      expand: false,
      builder: (context, scrollController) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CustomSheetHeader(widget.title),
          if (_hasSearch)
            _CustomSheetSearchField(
              controller: _searchController,
              hint: widget.searchHint,
              onChanged: _cubit.search,
            ),
          Expanded(
            child: BlocConsumer<CustomSheetCubit<T>, CustomSheetState<T>>(
              bloc: _cubit,
              listenWhen: (prev, curr) {
                if (curr.status is! DataSuccess) return false;
                return prev.status != curr.status || prev.filteredItems.length != curr.filteredItems.length;
              },
              listener: (_, state) => _onContentChanged(
                filteredCount: state.filteredItems.length,
                totalCount: state.allItems.length,
              ),
              builder: (_, state) => switch (state.status) {
                DataInitial() || DataLoading() => CustomSheetShimmer(controller: scrollController),
                DataSuccess() => CustomSheetItemList<T>(
                  items: state.filteredItems,
                  titleBuilder: widget.titleBuilder,
                  subtitleBuilder: widget.subtitleBuilder,
                  selectedItem: widget.selectedItem,
                  controller: scrollController,
                  emptyMessage: widget.emptyMessage,
                  itemBuilder: widget.itemBuilder,
                  separator: widget.separator,
                ),
                DataFailure(:final exception) => SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
                  child: ErrorBodyWidget(exception, onRetryPressed: _retry),
                ),
              },
            ),
          ),
          if (widget.footer != null) widget.footer!,
        ],
      ),
    );
  }
}

class _CustomSheetHeader extends StatelessWidget {
  const _CustomSheetHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.x4, 0, AppSpacing.x4, AppSpacing.x4),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: context.textTheme.titleLarge,
      ),
    );
  }
}

class _CustomSheetSearchField extends StatelessWidget {
  const _CustomSheetSearchField({
    required this.controller,
    required this.onChanged,
    this.hint,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.x4, 0, AppSpacing.x4, AppSpacing.x4),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search_rounded),
        ),
      ),
    );
  }
}
