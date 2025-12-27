part of '../widgets.dart';

class WMoreButtonIcon<T> extends StatelessWidget {
  const WMoreButtonIcon({
    required this.items,
    this.enabled = true,
    this.onSelected,
    this.iconColor,
    super.key,
  });

  final bool enabled;
  final List<PopupMenuEntry<T>> items;
  final void Function(T value)? onSelected;
  final Color? iconColor;

  @override
  Widget build(final BuildContext context) {
    return PopupMenuButton<T>(
      enabled: enabled,
      position: PopupMenuPosition.under,
      // tooltip: s.more,
      borderRadius: BorderRadius.circular(50),
      onSelected: onSelected,
      itemBuilder: (final context) => items,
      child: Center(
        child: Icon(
          Icons.more_vert_rounded,
          color: iconColor,
        ),
      ).pAll(5),
    );
  }
}
