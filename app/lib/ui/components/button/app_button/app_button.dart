import 'dart:ui';

import 'package:flutter/material.dart';

part 'app_button_body.dart';
part 'app_button_collapse_controller.dart';
part 'app_button_config.dart';
part 'app_button_style.dart';
part 'app_button_theme.dart';
part 'app_button_content.dart';
part 'app_button_scope.dart';

/// A themeable, portable button with primary/secondary/outline variants,
/// loading state, disabled state, and an optional collapse-on-scroll behavior.
///
/// See the package README for a full usage guide.
class AppButton extends StatefulWidget {
  const AppButton({
    required this.child,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.semanticLabel,
    this.autofocus = false,
    this.focusNode,
    this.expand = true,
    this.collapseOnScroll = false,
    this.scrollController,
    this.collapseThreshold = 50,
    this.collapsedIcon,
    this.animationDuration = const Duration(milliseconds: 250),
    super.key,
  }) : assert(
         !collapseOnScroll || expand,
         'collapseOnScroll requires expand=true so there is a width to collapse from.',
       );

  /// The primary content. Usually a [Text], but can be any widget.
  final Widget child;

  /// Tap callback. Passing `null` renders the button in its disabled (passive)
  /// state. The callback is also suppressed while [isLoading] is true.
  final VoidCallback? onPressed;

  final AppButtonVariant variant;
  final AppButtonSize size;

  /// When true, a circular progress indicator replaces the content and taps
  /// are ignored.
  final bool isLoading;

  /// Optional icon shown before [child].
  final Widget? leading;

  /// Optional icon shown after [child].
  final Widget? trailing;

  final String? semanticLabel;
  final bool autofocus;
  final FocusNode? focusNode;

  /// When true, the button stretches to the parent's max width. When false,
  /// it hugs its content.
  final bool expand;

  /// Enables the auto-collapse behavior. When the attached scrollable scrolls
  /// past [collapseThreshold], the button animates to a square FAB-like shape
  /// showing [collapsedIcon]. Defaults to `false` — opt-in per instance.
  final bool collapseOnScroll;

  /// Scroll controller to listen to. When `null` and [collapseOnScroll] is
  /// true, the ambient [PrimaryScrollController] is used.
  final ScrollController? scrollController;

  /// Scroll offset, in logical pixels, above which the button collapses.
  final double collapseThreshold;

  /// Widget shown in the collapsed state. Defaults to [Icons.arrow_forward].
  final Widget? collapsedIcon;

  /// Duration of the expand/collapse animation.
  final Duration animationDuration;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  AppButtonCollapseController? _collapseController;
  ScrollController? _boundScrollController;
  bool _usingScope = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reconfigureCollapse();
  }

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animationDuration != oldWidget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }

    final collapseConfigChanged =
        widget.collapseOnScroll != oldWidget.collapseOnScroll ||
        widget.collapseThreshold != oldWidget.collapseThreshold ||
        widget.scrollController != oldWidget.scrollController;

    if (collapseConfigChanged) {
      _disposeCollapseController();
      _reconfigureCollapse();
    }
  }

  @override
  void dispose() {
    _disposeCollapseController();
    _animationController.dispose();
    super.dispose();
  }

  /// Picks the collapse source for this button. Prefers an ambient
  /// [AppButtonScope] when present, otherwise falls back to a self-managed
  /// [AppButtonCollapseController] wired to the nearest scroll controller.
  void _reconfigureCollapse() {
    if (!widget.collapseOnScroll) {
      _usingScope = false;
      _disposeCollapseController();
      _animationController.reverse();
      return;
    }

    final scopeCollapsed = AppButtonScope.maybeCollapsedOf(context);
    if (scopeCollapsed != null) {
      if (!_usingScope) {
        _disposeCollapseController();
        _usingScope = true;
      }
      if (scopeCollapsed) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      return;
    }

    _usingScope = false;
    if (_collapseController == null) {
      _createCollapseController();
    }
    _bindScrollController();
  }

  void _createCollapseController() {
    _collapseController = AppButtonCollapseController(
      threshold: widget.collapseThreshold,
    )..addListener(_onCollapseChanged);
  }

  void _disposeCollapseController() {
    _collapseController
      ?..removeListener(_onCollapseChanged)
      ..dispose();
    _collapseController = null;
    _boundScrollController = null;
  }

  void _bindScrollController() {
    final next = widget.scrollController ?? PrimaryScrollController.maybeOf(context);
    if (identical(next, _boundScrollController)) return;
    _boundScrollController = next;
    _collapseController?.attach(next);
  }

  void _onCollapseChanged() {
    if (!mounted) return;
    final shouldCollapse = _collapseController?.isCollapsed ?? false;
    if (shouldCollapse) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  VoidCallback? get _effectiveOnPressed {
    if (widget.isLoading) return null;
    return widget.onPressed;
  }

  @override
  Widget build(BuildContext context) {
    final sizeConfig = AppButtonSizeConfig.of(widget.size);
    final theme = AppButtonTheme.of(context);
    final buttonStyle = AppButtonStyle.resolve(
      variant: widget.variant,
      sizeConfig: sizeConfig,
      theme: theme,
    );

    return AppButtonBody(
      animation: _animation,
      sizeConfig: sizeConfig,
      variant: widget.variant,
      theme: theme,
      style: buttonStyle,
      onPressed: _effectiveOnPressed,
      isLoading: widget.isLoading,
      expand: widget.expand,
      leading: widget.leading,
      trailing: widget.trailing,
      collapsedIcon: widget.collapsedIcon,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      semanticLabel: widget.semanticLabel,
      child: widget.child,
    );
  }
}
