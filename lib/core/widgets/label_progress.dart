part of 'widgets.dart';

class WLabelProgressBar extends StatefulWidget {
  const WLabelProgressBar({
    this.title,
    this.value = 0,
    this.progressColor,
    this.backgroundColor,
    this.duration = const Duration(seconds: 2),
    this.minTextWidth = 0,
    this.height = 10,
    this.thumbSize = 22,
    this.interactive = false,
    this.onChanged,
    super.key,
  }) : assert(value >= 0 && value <= 100, 'مقدار باید بین 0 و 100 باشد');

  /// عنوان یا برچسبی که در کنار نوار پیشرفت نمایش داده می‌شود.
  final String? title;

  /// مقدار نهایی پیشرفت که عددی بین 0 تا 100 است.
  final int value;

  /// رنگ نوار پیشرفت.
  final Color? progressColor;

  /// رنگ پس‌زمینه نوار پیشرفت.
  final Color? backgroundColor;

  /// مدت زمان انیمیشن برای رسیدن به مقدار نهایی.
  final Duration duration;

  /// حداقل عرض برای ویجت عنوان.
  final double minTextWidth;

  /// ارتفاع نوار پیشرفت.
  final double height;

  /// اندازه دستگیره
  final double thumbSize;

  /// اگر true باشد، کاربر می‌تواند با کلیک یا کشیدن مقدار را تغییر دهد.
  final bool interactive;

  /// یک تابع callback که با تغییر مقدار توسط کاربر فراخوانی می‌شود.
  /// مقدار جدید (0-100) را برمی‌گرداند.
  final ValueChanged<int>? onChanged;

  @override
  State<WLabelProgressBar> createState() => _WLabelProgressBarState();
}

class _WLabelProgressBarState extends State<WLabelProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double? _dragProgress; // برای نگهداری مقدار لحظه‌ای هنگام کشیدن

  /// تابع کمکی برای گرد کردن عدد به نزدیک‌ترین مضرب ۱۰
  int _roundToNearestTen(final int value) {
    return (value / 10).round() * 10;
  }

  /// تابع کمکی برای تبدیل درصد (0-100) به مقدار double (0.0-1.0)
  double _percentToDouble(final int value) {
    final double val = value / 100.0;
    return val.clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    final int roundedValue = widget.interactive ? _roundToNearestTen(widget.value) : widget.value;
    _animation = Tween<double>(begin: 0, end: _percentToDouble(roundedValue)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.value > 0) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant final WLabelProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      // مقدار جدید را نیز به نزدیک‌ترین مضرب ۱۰ گرد می‌کنیم
      final int roundedNewValue = widget.interactive ? _roundToNearestTen(widget.value) : widget.value;
      _animation = Tween<double>(
        begin: _animation.value,
        end: _percentToDouble(roundedNewValue),
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    // جهت متن فعلی (RTL یا LTR) را از context دریافت می‌کنیم.
    final bool isRtL = Directionality.of(context) == TextDirection.rtl;

    return AnimatedBuilder(
      animation: _controller,
      builder: (final context, final child) {
        final double displayProgress = _dragProgress ?? _animation.value;
        // فرمت درصد برای نمایش
        final String percentageText = '${(displayProgress * 100).toInt()}%';

        final Color color = displayProgress > 0.95
            ? AppColors.green
            : displayProgress > 0.25
                ? AppColors.orange
                : AppColors.red;

        final Widget thumb = Container(
          width: widget.thumbSize,
          height: widget.thumbSize,
          decoration: BoxDecoration(
            color: widget.progressColor ?? color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
        );

        final Widget progressBarCore = LinearProgressIndicator(
          value: displayProgress,
          minHeight: widget.height,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: widget.backgroundColor ?? Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(widget.progressColor ?? color),
        );

        final Widget interactiveProgressBar = LayoutBuilder(
          builder: (final layoutContext, final constraints) {
            if (!widget.interactive) {
              return progressBarCore;
            }
            // محاسبه موقعیت افقی دستگیره بر اساس مقدار پیشرفت
            // اگر RTL بود، موقعیت را از سمت راست محاسبه می‌کنیم
            final thumbPosition =
                isRtL ? (1 - displayProgress) * constraints.maxWidth - (widget.thumbSize / 2) : displayProgress * constraints.maxWidth - (widget.thumbSize / 2);

            // تابع کمکی برای محاسبه مقدار پیشرفت با گام‌های ۱۰تایی
            double calculateSnappingProgress(final Offset localPosition) {
              double progress = (localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0);
              // اگر زبان راست-به-چپ بود، مقدار را معکوس کن
              if (isRtL) {
                progress = 1.0 - progress;
              }
              // مقدار را به نزدیک‌ترین گام ۱۰ درصدی گرد کن
              return (progress * 10).round() / 10.0;
            }

            return GestureDetector(
              onTapUp: (final details) {
                if (widget.onChanged == null) return;
                final double newProgress = calculateSnappingProgress(details.localPosition);
                widget.onChanged!((newProgress * 100).round());
              },
              onHorizontalDragStart: (final details) {
                if (widget.onChanged == null) return;
                _controller.stop();
              },
              onHorizontalDragUpdate: (final details) {
                if (widget.onChanged == null) return;
                setState(() {
                  _dragProgress = calculateSnappingProgress(details.localPosition);
                });
              },
              onHorizontalDragEnd: (final details) {
                if (widget.onChanged == null) return;
                if (_dragProgress != null) {
                  final int finalValue = (_dragProgress! * 100).round();
                  widget.onChanged?.call(finalValue);
                  setState(() {
                    _dragProgress = null;
                  });
                }
              },
              child: Stack(
                alignment: Alignment.centerLeft, // برای راحتی در موقعیت‌دهی
                clipBehavior: Clip.none, // برای اینکه thumb بیرون از Stack دیده شود
                children: [
                  progressBarCore,
                  if (widget.interactive)
                    Positioned(
                      // ۳. موقعیت دستگیره را به صورت دینامیک تنظیم می‌کنیم
                      left: thumbPosition,
                      child: thumb,
                    ),
                ],
              ),
            );
          },
        );

        // چیدمان نهایی ویجت با استفاده از Row
        return Row(
          spacing: 8,
          children: [
            if ((widget.title ?? '') != '')
              Container(
                constraints: BoxConstraints(minWidth: widget.minTextWidth),
                child: Text(widget.title!, maxLines: 1).bodySmall(overflow: TextOverflow.ellipsis),
              ),
            interactiveProgressBar.expanded(),
            Container(
              width: 30,
              alignment: Alignment.center,
              child: Text(percentageText).bodySmall(),
            ),
          ],
        ).withTooltip("${widget.title ?? ''} $percentageText");
      },
    );
  }
}
