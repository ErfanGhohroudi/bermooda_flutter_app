part of 'widgets.dart';

class WCard extends StatelessWidget {
  const WCard({
    required this.child,
    this.padding = 12,
    this.horPadding,
    this.verPadding,
    this.elevation,
    this.color,
    this.headerColor,
    this.headerHeight = 15,
    this.margin,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2,
    this.onTap,
    this.glassEffect = false,
    this.blurSigma = 30.0,
    this.glassColor,
    super.key,
  });

  final Widget child;
  final double padding;
  final double? horPadding;
  final double? verPadding;
  final double? elevation;
  final Color? color;
  final Color? headerColor;
  final double headerHeight;
  final EdgeInsetsGeometry? margin;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final bool glassEffect;
  final double blurSigma;

  /// Default: ([color] ?? [Theme].of([context]).[cardColor]).withValues(alpha: 0.1)
  final Color? glassColor;

  @override
  Widget build(final BuildContext context) {
    final card = Card(
      color: glassEffect ? (glassColor ?? (color ?? Theme.of(context).cardColor).withValues(alpha: 0.1)) : color,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: showBorder ? BorderSide(color: borderColor ?? context.theme.shadowColor, width: borderWidth) : BorderSide.none,
      ),
      elevation: elevation,
      margin: glassEffect ? EdgeInsets.zero : margin,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              child: _body(context),
            )
          : _body(context),
    );

    if (glassEffect) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: card,
        ),
      );
    }

    return card;
  }

  Widget _body(final BuildContext context) => headerColor == null
      ? _child()
      : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: headerColor,
              width: context.width,
              height: headerHeight,
            ),
            _child(),
          ],
        );

  Widget _child() => Container(
        padding: EdgeInsets.symmetric(horizontal: horPadding ?? padding, vertical: verPadding ?? padding),
        child: child,
      );
}
