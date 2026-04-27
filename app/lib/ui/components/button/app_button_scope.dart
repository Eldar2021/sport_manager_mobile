import 'package:flutter/material.dart';

/// Default `Scaffold.floatingActionButtonLocation` for screens that pair an
/// `AppButton` with an [AppButtonScope]. `centerDocked` keeps the expanded
/// button flush with the bottom edge and places the collapsed FAB at the
/// bottom-right (after the button's own `Align(centerRight)`).
const FloatingActionButtonLocation kAppButtonFabLocation = FloatingActionButtonLocation.centerDocked;

/// Screen-level coordinator for collapsible `AppButton`s.
///
/// Wrap any subtree (typically a [Scaffold]) with this widget. It registers
/// **one** [WidgetsBindingObserver] and **one** scroll listener for the whole
/// subtree, then publishes a single `collapsed` boolean that descendant
/// `AppButton`s with `collapseOnScroll: true` consume — instead of every
/// button registering its own observers.
///
/// The scope flips `collapsed` to `true` when:
///   - the scroll offset exceeds [scrollThreshold] (with [hysteresis]), OR
///   - the soft keyboard becomes visible (when [observeKeyboard] is true).
///
/// ```dart
/// AppButtonScope(
///   child: Scaffold(
///     body: Form(...),
///     bottomNavigationBar: Padding(
///       padding: const EdgeInsets.all(AppSpacing.x4),
///       child: AppButton(
///         collapseOnScroll: true,
///         onPressed: _submit,
///         child: const Text('Continue'),
///       ),
///     ),
///   ),
/// )
/// ```
class AppButtonScope extends StatefulWidget {
  const AppButtonScope({
    required this.child,
    this.scrollController,
    this.scrollThreshold = 50,
    this.hysteresis = 8,
    this.observeKeyboard = true,
    this.keyboardMinHeight = 200,
    super.key,
  });

  final Widget child;

  /// Explicit scroll controller to observe. When `null`, the ambient
  /// [PrimaryScrollController] is used.
  final ScrollController? scrollController;

  /// Scroll offset above which the scope enters its collapsed state.
  final double scrollThreshold;

  /// Hysteresis around [scrollThreshold] to prevent flicker near the edge.
  final double hysteresis;

  /// When `true`, the scope also collapses while the soft keyboard is visible.
  final bool observeKeyboard;

  /// Minimum `viewInsets.bottom`, in logical pixels, to treat as
  /// "keyboard visible".
  final double keyboardMinHeight;

  /// Returns the current collapsed state of the nearest scope, or `null` if
  /// no scope is found. Subscribes the calling context so rebuilds happen on
  /// state flips.
  static bool? maybeCollapsedOf(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_AppButtonScopeInherited>();
    return inherited?.collapsed;
  }

  @override
  State<AppButtonScope> createState() => _AppButtonScopeState();
}

class _AppButtonScopeState extends State<AppButtonScope> with WidgetsBindingObserver {
  late final _CollapseController _scrollCollapse;
  ScrollController? _boundController;
  bool _keyboardVisible = false;
  bool _collapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollCollapse = _CollapseController(
      threshold: widget.scrollThreshold,
      hysteresis: widget.hysteresis,
    )..addListener(_recompute);
    if (widget.observeKeyboard) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bindScrollController();
    if (widget.observeKeyboard) _checkKeyboard();
  }

  @override
  void didUpdateWidget(covariant AppButtonScope oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.observeKeyboard != oldWidget.observeKeyboard) {
      if (widget.observeKeyboard) {
        WidgetsBinding.instance.addObserver(this);
        _checkKeyboard();
      } else {
        WidgetsBinding.instance.removeObserver(this);
        _keyboardVisible = false;
        _recompute();
      }
    }

    if (widget.scrollController != oldWidget.scrollController) {
      _bindScrollController();
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!mounted || !widget.observeKeyboard) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _checkKeyboard();
    });
  }

  @override
  void dispose() {
    if (widget.observeKeyboard) {
      WidgetsBinding.instance.removeObserver(this);
    }
    _scrollCollapse
      ..removeListener(_recompute)
      ..dispose();
    super.dispose();
  }

  void _bindScrollController() {
    final next = widget.scrollController ?? PrimaryScrollController.maybeOf(context);
    if (identical(next, _boundController)) return;
    _boundController = next;
    _scrollCollapse.attach(next);
  }

  void _checkKeyboard() {
    final height = MediaQuery.of(context).viewInsets.bottom;
    final next = height > widget.keyboardMinHeight;
    if (next == _keyboardVisible) return;
    _keyboardVisible = next;
    _recompute();
  }

  void _recompute() {
    final next = _keyboardVisible || _scrollCollapse.isCollapsed;
    if (_collapsed == next) return;
    setState(() => _collapsed = next);
  }

  @override
  Widget build(BuildContext context) {
    return _AppButtonScopeInherited(collapsed: _collapsed, child: widget.child);
  }
}

class _AppButtonScopeInherited extends InheritedWidget {
  const _AppButtonScopeInherited({
    required this.collapsed,
    required super.child,
  });

  final bool collapsed;

  @override
  bool updateShouldNotify(_AppButtonScopeInherited oldWidget) => collapsed != oldWidget.collapsed;
}

/// Listens to a [ScrollController] and toggles a boolean when the user scrolls
/// past [threshold] (with [hysteresis] to prevent flicker near the edge).
class _CollapseController extends ValueNotifier<bool> {
  _CollapseController({
    this.threshold = 50,
    this.hysteresis = 8,
  }) : super(false);

  final double threshold;
  final double hysteresis;

  ScrollController? _controller;

  bool get isCollapsed => value;

  void attach(ScrollController? controller) {
    if (identical(_controller, controller)) return;
    detach();
    _controller = controller;
    _controller?.addListener(_onScroll);
    _onScroll();
  }

  void detach() {
    _controller?.removeListener(_onScroll);
    _controller = null;
  }

  void _onScroll() {
    final controller = _controller;
    if (controller == null || !controller.hasClients) return;

    final offset = controller.offset;
    if (!value && offset > threshold + hysteresis) {
      value = true;
    } else if (value && offset < threshold - hysteresis) {
      value = false;
    }
  }

  @override
  void dispose() {
    detach();
    super.dispose();
  }
}
