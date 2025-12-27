part of 'widgets.dart';

class WExpansionTile extends StatefulWidget {
  const WExpansionTile({
    required this.title,
    required this.child,
    required this.onChanged,
    this.titleWidget,
    this.value = false,
    this.scrollOffset = 200,
    this.startPadding = 12,
    this.horizontalTitleGap = 10,
    this.scrollController,
    this.icon,
    this.titleColor,
    this.iconColor,
    this.showDivider = true,
    super.key,
  });

  final bool value;
  final String title;
  final Widget? titleWidget;
  final String? icon;
  final Color? titleColor;
  final Color? iconColor;
  final Widget child;
  final double scrollOffset;
  final double startPadding;
  final double horizontalTitleGap;
  final Function(bool value) onChanged;
  final ScrollController? scrollController;
  final bool showDivider;

  @override
  State<WExpansionTile> createState() => _WExpansionTileState();
}

class _WExpansionTileState extends State<WExpansionTile> {
  Rx<bool> isOpen = false.obs;

  @override
  void initState() {
    isOpen(widget.value);
    super.initState();
  }

  @override
  void dispose() {
    isOpen.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WExpansionTile oldWidget) {
    if (oldWidget.scrollOffset != widget.scrollOffset) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsetsDirectional.only(start: widget.startPadding),
            horizontalTitleGap: widget.horizontalTitleGap,
            minTileHeight: 30,
            splashColor: Colors.transparent,
            leading: widget.icon != null
                ? UImage(
                    widget.icon!,
                    color: widget.iconColor ?? context.theme.primaryColorDark,
                    size: 25,
                  )
                : null,
            title: widget.titleWidget ?? Text(widget.title).bodyMedium(color: widget.titleColor),
            trailing: AnimatedRotation(
              turns: isOpen.value ? (isPersianLang ? 0.5 : 0) : (isPersianLang ? 0 : 0.5),
              duration: 500.milliseconds,
              curve: Curves.easeInOutExpo,
              child: Icon(Icons.keyboard_arrow_down_rounded, color: context.theme.hintColor),
            ),
            onTap: () {
              isOpen(!isOpen.value);
              if (isOpen.value && widget.scrollController != null) {
                WidgetsBinding.instance.addPostFrameCallback((final _) {
                  if (widget.scrollController!.hasClients) {
                    final maxScrollOffset = widget.scrollController!.position.maxScrollExtent;
                    final finalOffset = widget.scrollController!.offset + widget.scrollOffset;

                    widget.scrollController!.animateTo(
                      finalOffset < maxScrollOffset ? finalOffset : maxScrollOffset,
                      duration: 1.seconds,
                      curve: Curves.ease,
                    );
                  }
                });
              }
              widget.onChanged(isOpen.value);
            },
          ),
          if (isOpen.value && widget.showDivider) const Divider(height: 18),
          if (isOpen.value && !widget.showDivider) const SizedBox(height: 18),
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutExpo,
            child: SizedBox(
              width: double.infinity,
              child: isOpen.value ? widget.child : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
