part of 'widgets.dart';

class WTextButton extends StatelessWidget {
  const WTextButton({
    required this.text,
    required this.onPressed,
    this.color,
    this.textStyle,
    this.fontSize,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final TextStyle? textStyle;
  final double? fontSize;

  @override
  Widget build(final BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle ??
            context.textTheme.bodyMedium!.copyWith(
              color: color ?? context.theme.primaryColor,
              decoration: TextDecoration.underline,
              decorationColor: context.theme.primaryColor,
              fontSize: fontSize,
            ),
      ),
    );
  }
}

class WTextButton2 extends StatelessWidget {
  const WTextButton2({
    required this.text,
    required this.onPressed,
    this.onLongPress,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 20,
      child: Text(
        text,
        maxLines: 1,
        style: context.textTheme.bodyMedium!.copyWith(
          color: context.theme.primaryColor,
          decoration: TextDecoration.underline,
          decorationColor: context.theme.primaryColor,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ).onTap(onPressed).onLongPress(onLongPress);
  }
}
