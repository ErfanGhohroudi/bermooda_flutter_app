part of 'widgets.dart';

class WSmartRefresher extends StatefulWidget {
  const WSmartRefresher({
    required this.controller,
    this.scrollController,
    this.physics,
    this.onRefresh,
    this.onLoading,
    this.enablePullDown = true,
    this.enablePullUp = true,
    this.headerBackgroundColor = Colors.transparent,
    this.headerTextColor,
    this.child,
    super.key,
  });

  final RefreshController controller;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final Function()? onRefresh;
  final Function()? onLoading;
  final bool enablePullDown;
  final bool enablePullUp;
  final Color headerBackgroundColor;
  final Color? headerTextColor;
  final Widget? child;

  @override
  State<WSmartRefresher> createState() => _WSmartRefresherState();
}

class _WSmartRefresherState extends State<WSmartRefresher> {
  @override
  Widget build(final BuildContext context) {
    return SmartRefresher(
      controller: widget.controller,
      scrollController: widget.scrollController,
      physics: widget.physics,
      onRefresh: widget.onRefresh,
      onLoading: widget.onLoading,
      enablePullDown: widget.enablePullDown,
      enablePullUp: widget.enablePullUp,
      header: TwoLevelHeader(
        idleText: s.pullToRefresh,
        releaseText: s.releaseToRefresh,
        refreshingText: s.refreshing,
        failedText: s.failed,
        completeText: s.completed,
        textStyle: context.textTheme.bodySmall!.copyWith(color: widget.headerTextColor),
        refreshingIcon: WCircularLoading(strokeWidth: 2, size: 15,color: widget.headerTextColor),
        decoration: BoxDecoration(
          color: widget.headerBackgroundColor,
        ),
        idleIcon: Icon(Icons.arrow_downward_rounded, color: widget.headerTextColor?? Colors.grey),
        releaseIcon: Icon(Icons.arrow_upward_rounded, color: widget.headerTextColor?? Colors.grey),
        completeIcon: Icon(Icons.check_rounded, color: widget.headerTextColor?? Colors.grey),
        failedIcon: Icon(Icons.close_rounded, color: widget.headerTextColor?? Colors.grey),
      ),
      footer: ClassicFooter(
        canLoadingText: s.fetchMoreData,
        loadingText: s.loading,
        noDataText: "",
        failedText: s.failed,
        idleText: s.completed,
        textStyle: context.textTheme.bodySmall!,
        loadingIcon: const WCircularLoading(strokeWidth: 2, size: 15),
        height: 40,
        loadStyle: LoadStyle.ShowWhenLoading,
      ),
      child: widget.child,
    );
  }
}
