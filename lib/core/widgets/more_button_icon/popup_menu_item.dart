part of '../widgets.dart';

class WPopupMenuItem<int> extends PopupMenuEntry<int> {
  final int? value;
  final String title;
  final Color? titleColor;
  final String icon;
  final IconData? iconData;
  final Color? iconColor;
  final VoidCallback onTap;

  const WPopupMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconData,
    this.titleColor,
    this.iconColor,
    this.value,
    super.key,
  });

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(final int? value) => value == this.value;

  @override
  State<WPopupMenuItem> createState() => _WPopupMenuItemState();
}

class _WPopupMenuItemState extends State<WPopupMenuItem> {
  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: Text(widget.title).bodyMedium(color: widget.titleColor),
      leading: widget.iconData == null
          ? UImage(
              widget.icon,
              color: widget.iconColor ?? (context.isDarkMode ? Colors.white : Colors.black87),
              size: 25,
            )
          : Icon(
              widget.iconData,
              color: widget.iconColor ?? (context.isDarkMode ? Colors.white : Colors.black87),
              size: 25,
            ),
      minTileHeight: 10,
      shape: const ContinuousRectangleBorder(),
      horizontalTitleGap: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      onTap: () {
        UNavigator.back();
        delay(
          50,
          widget.onTap,
        );
      },
    );
  }
}
