part of 'widgets.dart';

/// ```dart
/// // Add These lines in controller mixin
/// // Pass [scrollController] to Scrollable Widget like [ListView]
///
/// final ScrollController scrollController = ScrollController();
/// final Rx<bool> showScrollToTop = false.obs;
///
/// // Add These lines in Page's [initState()]
/// // [300] is height that scroll to show button
///
/// scrollController.addListener(scrollListener);
///
/// void scrollListener() {
///   if (scrollController.offset > 300 && !showScrollToTop.value) {
///     showScrollToTop(true);
///   } else if (scrollController.offset <= 300 && showScrollToTop.value) {
///     showScrollToTop(false);
///   }
/// }
///
/// // Add These lines in [dispose()]
/// scrollController.removeListener(scrollListener);
/// scrollController.dispose();
/// showScrollToTop.close();
/// ```
class WScrollToTopButton extends StatefulWidget {
  const WScrollToTopButton({
    required this.scrollController,
    required this.show,
    this.bottomMargin = 24,
    this.icon = Icons.arrow_upward,
    super.key,
  });

  final ScrollController scrollController;
  final Rx<bool> show;
  final double bottomMargin;
  final IconData icon;

  @override
  State<WScrollToTopButton> createState() => _WScrollToTopButtonState();
}

class _WScrollToTopButtonState extends State<WScrollToTopButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  bool _show = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _fade.addListener(_listener);

    widget.show.listen((final visible) {
      if (visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _listener() {
    if (_fade.value == 0.0) {
      if (mounted) {
        setState(() {
          _show = false;
        });
      }
    } else if (_fade.isAnimating && _fade.value > 0.01 && _fade.value < 0.02) {
      if (mounted) {
        setState(() {
          _show = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _fade.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Visibility(
      visible: _show,
      child: Positioned(
        bottom: widget.bottomMargin,
        right: 18,
        child: FadeTransition(
          opacity: _fade,
          child: FloatingActionButton(
            heroTag: "scrollToTopFAB",
            mini: true,
            backgroundColor: context.theme.hintColor.withAlpha(150),
            onPressed: () {
              widget.scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            },
            child: Icon(widget.icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
