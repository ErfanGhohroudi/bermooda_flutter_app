part of 'widgets.dart';

class WLabel extends StatefulWidget {
  const WLabel({
    this.user,
    this.text,
    this.color,
    this.textColor,
    this.height,
    this.minWidth = 50,
    this.borderRadius = 8,
    this.verticalPadding = 5,
    super.key,
  })  : assert(text != null || user != null, "Insert text or user"),
        assert(text == null || user == null, "Must use one of them");

  final UserReadDto? user;
  final String? text;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double minWidth;
  final double borderRadius;
  final double verticalPadding;

  @override
  State<WLabel> createState() => _WLabelState();
}

class _WLabelState extends State<WLabel> {
  @override
  Widget build(final BuildContext context) {
    return Container(
      height: widget.height,
      constraints: BoxConstraints(minWidth: widget.minWidth),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: widget.verticalPadding),
      decoration: BoxDecoration(
        color: (widget.color ?? context.theme.hintColor).withAlpha(20),
        border: Border.all(color: widget.color?.withValues(alpha: 0.3) ?? Colors.transparent, width: 2),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: widget.text != null
            ? Text(widget.text!).bodySmall(color: widget.textColor ?? widget.color ?? context.theme.hintColor).bold()
            : widget.user != null
                ? WCircleAvatar(
                    user: widget.user!,
                    size: 20,
                    showFullName: true,
                    expand: false,
                    bodySmall: true,
                    nameColor: widget.textColor ?? widget.color ?? context.theme.hintColor,
                  )
                : const SizedBox(),
      ),
    );
  }
}
