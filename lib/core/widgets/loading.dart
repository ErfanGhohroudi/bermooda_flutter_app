part of 'widgets.dart';

class WCircularLoading extends StatelessWidget {
  const WCircularLoading({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.size = 30,
    this.strokeWidth = 4.0,
  });

  final double? value;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final double strokeWidth;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        color: color ?? context.theme.primaryColor,
        backgroundColor: backgroundColor,
        strokeCap: StrokeCap.round,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
