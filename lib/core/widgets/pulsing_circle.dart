part of 'widgets.dart';

class WPulsingCircle extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const WPulsingCircle({
    super.key,
    this.size = 15.0,
    this.color = Colors.orange,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<WPulsingCircle> createState() => _WPulsingCircleState();
}

class _WPulsingCircleState extends State<WPulsingCircle> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // تعریف انیمیشن برای بزرگ شدن از ۱ برابر به ۲ برابر اندازه اولیه
    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // تعریف انیمیشن پیچیده‌تر برای شفافیت
    _opacityAnimation = TweenSequence<double>([
      // در ۷۰٪ اول زمان انیمیشن، شفافیت ثابت و برابر ۰.۳ است
      TweenSequenceItem(tween: ConstantTween<double>(0.3), weight: 70),
      // در ۳۰٪ پایانی، شفافیت از ۰.۳ به صفر می‌رسد (محو می‌شود)
      TweenSequenceItem(tween: Tween<double>(begin: 0.3, end: 0.0), weight: 30),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // اجرای بی‌نهایت و یک‌طرفه انیمیشن
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // این ویجت موج انیمیشنی را می‌سازد
        AnimatedBuilder(
          animation: _controller,
          builder: (final context, final child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
              ),
            );
          },
        ),

        // این دایره ثابت وسط است
        Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withAlpha(150),
          ),
        ),
      ],
    );
  }
}

