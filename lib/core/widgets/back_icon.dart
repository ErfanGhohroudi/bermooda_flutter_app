part of 'widgets.dart';

class WBackIcon extends StatelessWidget {
  const WBackIcon({
    this.action,
    this.color,
    this.size = 30,
    super.key,
  });

  final VoidCallback? action;
  final Color? color;
  final double? size;

  @override
  Widget build(final BuildContext context) {
    return Icon(Icons.arrow_back_rounded, color: color ?? context.theme.primaryColorDark, size: size).onTap(() {
      if (action != null) {
        action!();
      } else {
        UNavigator.back();
      }
    });
  }
}
