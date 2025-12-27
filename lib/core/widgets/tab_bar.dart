part of 'widgets.dart';

class WTabBar extends StatelessWidget implements PreferredSizeWidget {
  const WTabBar({
    required this.controller,
    required this.tabs,
    this.height = kToolbarHeight,
    this.backgroundColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.isScrollable = false,
    this.tabAlignment,
    this.horizontalPadding = 0,
    this.horizontalLabelPadding = 0,
    this.horizontalIndicatorPadding = 0,
    this.indicator,
    this.indicatorColor,
    this.dividerColor,
    this.indicatorWeight = 3,
    this.indicatorAnimation = TabIndicatorAnimation.elastic,
    this.indicatorSize = TabBarIndicatorSize.label,
    super.key,
  });

  final TabController controller;

  /// The Tab's icon must be [Icon] or [UImage] or null
  final List<Tab> tabs;
  final double height;
  final Color? backgroundColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool isScrollable;
  final TabAlignment? tabAlignment;
  final double horizontalPadding;
  final double horizontalLabelPadding;
  final double horizontalIndicatorPadding;
  final Decoration? indicator;
  final Color? indicatorColor;
  final Color? dividerColor;
  final double indicatorWeight;
  final TabIndicatorAnimation indicatorAnimation;
  final TabBarIndicatorSize indicatorSize;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(final BuildContext context) {
    final labelColor = this.labelColor ?? (Get.isDarkMode ? context.theme.primaryColorDark : context.theme.primaryColor);
    final unselectedLabelColor = this.unselectedLabelColor ?? context.theme.primaryColorDark.withAlpha(100);
    var tabs = <Tab>[];
    for (int i = 0; i < this.tabs.length; i++) {
      tabs.add(
        Tab(
          text: this.tabs[i].text,
          icon: this.tabs[i].icon is UImage
              ? _AnimatedTabBuilder(
                  controller: controller,
                  thisIndex: i,
                  selectedColor: labelColor,
                  unselectedColor: unselectedLabelColor,
                  builder: (final context, final color) => UImage((this.tabs[i].icon as UImage).source, color: color, size: (this.tabs[i].icon as UImage).size),
                )
              : this.tabs[i].icon,
        ),
      );
    }

    return Container(
      color: backgroundColor ?? context.theme.cardColor,
      child: TabBar(
        controller: controller,
        tabs: tabs,
        isScrollable: isScrollable,
        dividerHeight: 1,
        dividerColor: dividerColor,
        tabAlignment: tabAlignment ?? (isScrollable ? TabAlignment.start : null),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        labelPadding: EdgeInsets.symmetric(horizontal: horizontalLabelPadding),
        indicatorPadding: EdgeInsets.symmetric(horizontal: horizontalIndicatorPadding),
        labelColor: labelColor,
        labelStyle: labelStyle ?? context.textTheme.bodyMedium,
        unselectedLabelColor: unselectedLabelColor,
        unselectedLabelStyle: unselectedLabelStyle ?? context.textTheme.bodyMedium,
        indicator: indicator ??
            UnderlineTabIndicator(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: indicatorColor ?? (Get.isDarkMode ? context.theme.primaryColorDark : context.theme.primaryColor),
                width: indicatorWeight,
              ),
            ),
        indicatorAnimation: indicatorAnimation,
        indicatorSize: indicatorSize,
      ),
    );
  }
}

class WTabBarView extends StatelessWidget {
  const WTabBarView({
    required this.controller,
    required this.pages,
    super.key,
  });

  final TabController controller;
  final List<LazyKeepAliveTabView> pages;

  @override
  Widget build(final BuildContext context) {
    return TabBarView(
      controller: controller,
      viewportFraction: 1,
      children: pages,
    );
  }
}

class LazyKeepAliveTabView extends StatefulWidget {
  final Widget Function() builder;

  const LazyKeepAliveTabView({
    required this.builder,
    super.key,
  });

  @override
  State<LazyKeepAliveTabView> createState() => _LazyKeepAliveTabViewState();
}

class _LazyKeepAliveTabViewState extends State<LazyKeepAliveTabView> with AutomaticKeepAliveClientMixin {
  late final Widget _child = widget.builder();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(final BuildContext context) {
    super.build(context); // for keep-alive
    return _child;
  }
}

class WStyledTabBar extends StatelessWidget {
  const WStyledTabBar({
    required this.controller,
    required this.tabs,
    this.isScrollable = false,
    this.minHeight = 45,
    this.maxHeight = 45,
    this.margin,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    super.key,
  });

  final TabController controller;
  final List<Tab> tabs;
  final bool isScrollable;
  final double minHeight;
  final double maxHeight;
  final EdgeInsetsGeometry? margin;
  final Color? unselectedLabelColor;
  final TextStyle? unselectedLabelStyle;

  @override
  Widget build(final BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight, maxHeight: maxHeight),
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(50),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TabBar(
          controller: controller,
          isScrollable: isScrollable,
          tabAlignment: (isScrollable ? TabAlignment.start : null),
          tabs: tabs,
          labelColor: Colors.white,
          labelStyle: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelColor: unselectedLabelColor ?? context.theme.primaryColorDark.withAlpha(100),
          unselectedLabelStyle: unselectedLabelStyle ?? context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          // unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          indicator: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: BorderRadius.circular(25.0),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerHeight: 0,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          indicatorAnimation: TabIndicatorAnimation.elastic,
        ),
      ),
    );
  }
}

typedef TabChildBuilder = Widget Function(BuildContext context, Color color);

class _AnimatedTabBuilder extends StatefulWidget {
  const _AnimatedTabBuilder({
    required this.controller,
    required this.thisIndex,
    required this.selectedColor,
    required this.unselectedColor,
    required this.builder,
  });

  final TabController controller;
  final int thisIndex;
  final Color selectedColor;
  final Color unselectedColor;
  final TabChildBuilder builder;

  @override
  State<_AnimatedTabBuilder> createState() => _AnimatedTabBuilderState();
}

class _AnimatedTabBuilderState extends State<_AnimatedTabBuilder> {
  @override
  void initState() {
    super.initState();
    widget.controller.animation!.addListener(_handleAnimation);
  }

  @override
  void dispose() {
    widget.controller.animation!.removeListener(_handleAnimation);
    super.dispose();
  }

  void _handleAnimation() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant final _AnimatedTabBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.animation!.removeListener(_handleAnimation);
      widget.controller.animation!.addListener(_handleAnimation);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final animationValue = widget.controller.animation!.value;
    final selectionProgress = (1.0 - (animationValue - widget.thisIndex).abs()).clamp(0.0, 1.0);
    final color = Color.lerp(widget.unselectedColor, widget.selectedColor, selectionProgress)!;

    // ✅ تابع سازنده را با رنگ محاسبه شده فراخوانی می‌کنیم
    return widget.builder(context, color);
  }
}
