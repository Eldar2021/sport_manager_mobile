part of 'app_button.dart';

/// Listens to a [ScrollController] and toggles a collapsed/expanded boolean
/// state when the user scrolls past [threshold].
///
/// Hysteresis prevents flicker when the offset oscillates around the threshold.
class AppButtonCollapseController extends ValueNotifier<bool> {
  AppButtonCollapseController({
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
