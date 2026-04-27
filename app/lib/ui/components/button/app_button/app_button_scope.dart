part of 'app_button.dart';

/// Screen-level coordinator for collapsible [AppButton]s.
///
/// Wrap any subtree (usually a [Scaffold]) with this widget. It registers
/// **one** [WidgetsBindingObserver] and **one** scroll listener for the whole
/// subtree, and publishes a single `collapsed` boolean that descendant
/// [AppButton]s with `collapseOnScroll: true` automatically consume — instead
/// of each button registering its own observers.
///
/// When present, the scope drives collapse on:
///   - Scroll offset exceeding [scrollThreshold] (with [hysteresis])
///   - Keyboard becoming visible (if [observeKeyboard] is `true`)
///
/// ```dart
/// AppButtonScope(
///   child: Scaffold(
///     body: ListView.builder(...),
///     bottomNavigationBar: Padding(
///       padding: const EdgeInsets.all(16),
///       child: AppButton(
///         collapseOnScroll: true,
///         child: const Text('Devam'),
///         onPressed: _next,
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

  /// Scroll offset above which the scope enters the collapsed state.
  final double scrollThreshold;

  /// Hysteresis around [scrollThreshold] to prevent flicker near the edge.
  final double hysteresis;

  /// When `true`, the scope also collapses while the software keyboard is
  /// visible.
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
  late final AppButtonCollapseController _scrollCollapse;
  ScrollController? _boundController;
  bool _keyboardVisible = false;
  bool _collapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollCollapse = AppButtonCollapseController(
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
    if (widget.observeKeyboard) {
      _checkKeyboard();
    }
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
    return _AppButtonScopeInherited(
      collapsed: _collapsed,
      child: widget.child,
    );
  }
}

class _AppButtonScopeInherited extends InheritedWidget {
  const _AppButtonScopeInherited({
    required this.collapsed,
    required super.child,
  });

  final bool collapsed;

  @override
  bool updateShouldNotify(_AppButtonScopeInherited oldWidget) {
    return collapsed != oldWidget.collapsed;
  }
}
