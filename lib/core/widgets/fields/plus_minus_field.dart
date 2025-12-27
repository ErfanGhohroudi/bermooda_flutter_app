part of 'fields.dart';

class WPlusMinusField extends StatefulWidget {
  const WPlusMinusField({
    required this.onChanged,
    this.onIncrease,
    this.onDecrease,
    this.required = false,
    this.enable = true,
    this.enableTyping = true,
    this.labelText,
    this.range = 1,
    this.defaultValue = 0,
    this.max = 999999999,
    this.maximumColor,
    this.minimumColor,
    this.addWidget,
    this.minusWidget,
    super.key,
  });

  final bool required;
  final bool enable;
  final bool enableTyping;
  final String? labelText;
  final Function(int value) onChanged;
  final Function(int value)? onIncrease;
  final Function(int value)? onDecrease;
  final int range;
  final int defaultValue;
  final int max;
  final Color? maximumColor;
  final Color? minimumColor;
  final Widget? addWidget;
  final Widget? minusWidget;

  @override
  State<WPlusMinusField> createState() => _WPlusMinusFieldState();
}

class _WPlusMinusFieldState extends State<WPlusMinusField> {
  late final TextEditingController currentAmountController;

  int get currentAmount => currentAmountController.text.numericOnly().toInt();

  @override
  void initState() {
    currentAmountController = TextEditingController(text: widget.defaultValue.toString());
    super.initState();
  }

  @override
  void dispose() {
    currentAmountController.dispose();
    super.dispose();
  }

  void increaseAmount() {
    if (!mounted) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (currentAmount < widget.max && widget.enable) {
      setState(() {
        currentAmountController.text = (currentAmount + widget.range).toString().separateNumbers3By3();
      });
      widget.onIncrease?.call(currentAmount);
      widget.onChanged(currentAmount);
    }
  }

  void decreaseAmount() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (currentAmount > widget.range - 1 && widget.enable) {
      setState(() {
        currentAmountController.text = (currentAmount - widget.range).toString().separateNumbers3By3();
      });
      widget.onDecrease?.call(currentAmount);
      widget.onChanged(currentAmount);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return UTextFormField(
      enabled: widget.enable,
      readOnly: !widget.enableTyping,
      controller: currentAmountController,
      labelText: widget.labelText,
      required: widget.required,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      formatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
        ThousandsSeparatorInputFormatter(),
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: () {
        if (!widget.enableTyping) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      validator: (final value) {
        if (currentAmount < 1 && widget.required) return s.requiredField;
        return null;
      },
      onChanged: (final value) {
        if (currentAmount > widget.max) {
          currentAmountController.text = widget.max.toString();
        }
        widget.onIncrease?.call(currentAmount);
        widget.onChanged(currentAmount);
        setState(() {});
      },
      suffixIcon: isPersianLang ? _minusButton() : _addButton(),
      prefixIcon: !isPersianLang ? _minusButton() : _addButton(),
    );
  }

  Widget _addButton() => Center(
        widthFactor: 1,
        heightFactor: 1,
        child: GestureDetector(
          onTap: increaseAmount,
          child: widget.addWidget ??
              UImage(
                AppIcons.addSquareOutline,
                color: currentAmount < widget.max ? context.theme.primaryColor : widget.maximumColor ?? context.theme.hintColor,
                size: 25,
              ),
        ),
      );

  Widget _minusButton() => Center(
        widthFactor: 1,
        heightFactor: 1,
        child: GestureDetector(
          onTap: decreaseAmount,
          child: widget.minusWidget ??
              UImage(
                AppIcons.minusSquareOutline,
                color: currentAmount > 0 ? AppColors.red : widget.minimumColor ?? context.theme.hintColor,
                size: 25,
              ),
        ),
      );
}
