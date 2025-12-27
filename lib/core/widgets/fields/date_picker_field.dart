part of 'fields.dart';

class WDatePickerField extends StatefulWidget {
  WDatePickerField({
    required this.onConfirm,
    this.initialValue, // yyyy/mm/dd
    this.startDate,
    this.labelText,
    this.enabled = true,
    this.required = false,

    /// set [false] if you want to hide [*] after [labelText]
    this.showRequired,
    this.showYearSelector = false,
    this.validator,
    this.enableClearButton = true,
    super.key,
  }) : assert(initialValue == null || initialValue.toJalali() != null, 'initialValue format is not yyyy/mm/dd');

  final Function(Jalali? date, String? compactFormatterDate) onConfirm;
  final String? initialValue;
  final Jalali? startDate;
  final String? labelText;
  final bool enabled;
  final bool required;
  final bool? showRequired;
  final bool showYearSelector;
  final FormFieldValidator<String?>? validator;
  final bool enableClearButton;

  @override
  State<WDatePickerField> createState() => _WDatePickerFieldState();
}

class _WDatePickerFieldState extends State<WDatePickerField> {
  Jalali? currentDate;
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    setInitialDate();
    super.initState();
  }

  void setInitialDate() {
    currentDate = widget.initialValue.toJalali();
    dateController.text = currentDate?.formatCompactDate() ?? '';
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WDatePickerField oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      setState(() {
        setInitialDate();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return UTextFormField(
      enabled: widget.enabled,
      controller: dateController,
      labelText: widget.labelText ?? s.date,
      required: widget.showRequired ?? widget.required,
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator ??
          (widget.required
              ? validateNotEmpty(
                  requiredMessage: s.requiredField,
                )
              : null),
      onTap: () async {
        FocusManager.instance.primaryFocus!.unfocus();
        if (widget.enabled) {
          final hadInitialValue = dateController.text.isNotEmpty;
          final result = await DateAndTimeFunctions.showCustomPersianDatePicker(
            startDate: widget.startDate,
            initialDate: dateController.text.toJalali(),
            showYearSelector: widget.showYearSelector,
            barrierDismissible: false,
            enableClearButton: widget.enableClearButton,
          );
          FocusManager.instance.primaryFocus!.unfocus();
          if (result != null && result.year > 0) {
            currentDate = result;
            dateController.text = currentDate!.formatCompactDate();
            widget.onConfirm(currentDate!, currentDate!.formatCompactDate());
          } else if (result != null  && result.year <= 0 && hadInitialValue && widget.enableClearButton) {
            // Handle clear button click - result is Jalali(0) when clear is pressed
            // Only clear if there was an initial value and clear button is enabled
            currentDate = null;
            dateController.text = '';
            // Call onConfirm with null values - parent should handle null value as cleared date
            widget.onConfirm(null, null);
          }
        }
      },
      suffixIcon: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: UImage(AppIcons.calendarOutline, color: context.theme.hintColor, size: 20),
      ),
    );
  }
}
