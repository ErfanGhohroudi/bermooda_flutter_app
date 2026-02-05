import 'package:u/utilities.dart';

class WStepper extends StatelessWidget {
  const WStepper({
    required this.stepsLength,
    required this.currentStep,
    required this.currentStepTitle,
    required this.currentStepContent,
    this.height = 40,
    this.trackerColor,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    super.key,
  });

  final int stepsLength;
  final int currentStep;
  final String currentStepTitle;
  final Widget currentStepContent;
  final double height;
  final Color? trackerColor;
  final EdgeInsets contentPadding;

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        _buildStepperIndicator(
          context,
          stepsLength: stepsLength,
          currentStepTitle: currentStepTitle,
          currentStep: currentStep,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: contentPadding,
          child: currentStepContent,
        ).expanded(),
      ],
    );
  }

  Widget _buildStepperIndicator(
    final BuildContext context, {
    required final int currentStep,
    required final int stepsLength,
    required final String currentStepTitle,
  }) {
    return Row(
      children: [
        Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadiusGeometry.directional(
              topEnd: Radius.circular(10),
              bottomEnd: Radius.circular(10),
            ),
          ),
          child: Text(currentStepTitle).titleMedium(color: context.theme.primaryColor).bold().alignAtCenter(),
        ),
        Container(
          height: height,
          decoration: const BoxDecoration(
            borderRadius: BorderRadiusGeometry.directional(
              topStart: Radius.circular(10),
              bottomStart: Radius.circular(10),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: StepperProgress(
            currentStep: currentStep,
            stepsLength: stepsLength,
            trackerColor: trackerColor ?? context.theme.dividerColor,
          ),
        ).expanded(),
      ],
    );
  }
}

class StepperProgress extends StatefulWidget {
  const StepperProgress({
    this.currentStepTitle,
    this.currentStep = 0,
    required this.stepsLength,
    this.progressColor,
    this.trackerColor,
    this.duration = const Duration(milliseconds: 800),
    this.maxTextWidth = 0,
    this.trackerHeight = 10,
    this.thumbSize = 25,
    super.key,
  }) : assert(currentStep >= 0 && currentStep < stepsLength, 'مقدار باید بین 0 و "stepsLength" باشد');

  /// عنوان یا برچسبی که در کنار نوار پیشرفت نمایش داده می‌شود.
  final String? currentStepTitle;

  final int currentStep;

  final int stepsLength;

  /// رنگ نوار پیشرفت.
  final Color? progressColor;

  /// رنگ پس‌زمینه نوار پیشرفت.
  final Color? trackerColor;

  /// مدت زمان انیمیشن برای رسیدن به مقدار نهایی.
  final Duration duration;

  /// حداکثر عرض برای ویجت عنوان.
  final double maxTextWidth;

  /// ارتفاع نوار پیشرفت.
  final double trackerHeight;

  /// اندازه دستگیره
  final double thumbSize;

  @override
  State<StepperProgress> createState() => _StepperProgressState();
}

class _StepperProgressState extends State<StepperProgress> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int get currentStepValue => widget.currentStep + 1;

  /// تابع کمکی برای تبدیل مرحله به مقدار double (0.0-1.0)
  double _stepToDouble(final int value) {
    final double val = (value + 1) / widget.stepsLength;
    return val.clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: _stepToDouble(widget.currentStep)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.currentStep >= 0) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant final StepperProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != oldWidget.currentStep || widget.stepsLength != oldWidget.stepsLength) {
      _animation =
          Tween<double>(
            begin: _animation.value,
            end: _stepToDouble(widget.currentStep),
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
        final double displayValue = _animation.value;

        final Color color = context.theme.primaryColor;

        final thumbWidth = widget.thumbSize + (widget.thumbSize * 0.5);

        final Widget thumb = Container(
          width: thumbWidth,
          height: widget.thumbSize,
          decoration: BoxDecoration(
            color: widget.progressColor ?? color,
            borderRadius: BorderRadiusGeometry.circular(5),
          ),
          child: Text(currentStepValue.toString()).titleMedium(color: Colors.white).alignAtCenter(),
        );

        final Widget progressBarCore = LinearProgressIndicator(
          value: displayValue,
          minHeight: widget.trackerHeight,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: widget.trackerColor ?? Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(widget.progressColor ?? color),
        );

        final Widget interactiveProgressBar = LayoutBuilder(
          builder: (final layoutContext, final constraints) {
            final isLastStep = currentStepValue == widget.stepsLength;

            final thumbWidthCenter = isLastStep ? 0 : (thumbWidth / 2);

            // محاسبه موقعیت افقی دستگیره بر اساس مقدار پیشرفت
            // اگر RTL بود، موقعیت را از سمت راست محاسبه می‌کنیم
            final thumbPosition = isRtL
                ? (1 - displayValue) * constraints.maxWidth - thumbWidthCenter
                : displayValue * constraints.maxWidth - thumbWidthCenter;

            return Stack(
              alignment: Alignment.centerLeft, // برای راحتی در موقعیت‌دهی
              clipBehavior: Clip.none, // برای اینکه thumb بیرون از Stack دیده شود
              children: [
                progressBarCore,
                Positioned(
                  // ۳. موقعیت دستگیره را به صورت دینامیک تنظیم می‌کنیم
                  left: thumbPosition,
                  child: thumb,
                ),
              ],
            );
          },
        );

        // چیدمان نهایی ویجت با استفاده از Row
        return Row(
          spacing: 8,
          children: [
            if ((widget.currentStepTitle ?? '').isNotEmpty)
              Container(
                constraints: BoxConstraints(maxWidth: widget.maxTextWidth),
                child: Text(widget.currentStepTitle!, maxLines: 1).bodySmall(overflow: TextOverflow.ellipsis),
              ),
            interactiveProgressBar.expanded(),
          ],
        );
      },
    );
  }
}
