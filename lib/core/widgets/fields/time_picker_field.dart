part of 'fields.dart';

class WTimePickerField extends StatefulWidget {
  const WTimePickerField({
    required this.onConfirm,
    this.initialValue, // HH:MM
    this.labelText,
    this.enabled = true,
    this.required = false,

    /// set [false] if you want to hide [*] after [labelText]
    this.showRequired,
    this.validator,
    this.enableClearButton = true,
    super.key,
  });

  final Function(String? time, TimeOfDay? timeOfDay) onConfirm;
  final String? initialValue;
  final String? labelText;
  final bool enabled;
  final bool required;
  final bool? showRequired;
  final FormFieldValidator<String?>? validator;
  final bool enableClearButton;

  @override
  State<WTimePickerField> createState() => _WTimePickerFieldState();
}

class _WTimePickerFieldState extends State<WTimePickerField> {
  TimeOfDay? currentValue;

  String? get timeStr => currentValue != null
      ? '${currentValue!.hour.toString().padLeft(2, '0')}:${currentValue!.minute.toString().padLeft(2, '0')}'
      : null;


  @override
  void initState() {
    _setInitialDate();
    super.initState();
  }

  void _setInitialDate() {
    if (widget.initialValue == null || widget.initialValue == '') {
      currentValue = null;
      return;
    }
    final hourStr = widget.initialValue?.split(':').firstOrNull?.numericOnly();
    final minuteStr = widget.initialValue?.split(':').lastOrNull?.numericOnly();
    final hour = int.tryParse(hourStr ?? '') ?? 0;
    final minute = int.tryParse(minuteStr ?? '') ?? 0;
    currentValue = TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WTimePickerField oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      _setInitialDate();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _showTimePicker(final FormFieldState<TimeOfDay?> state) {
    TimeOfDay time = currentValue ?? TimeOfDay.now();

    bottomSheet(
      title: s.selectTime,
      childBuilder: (final _) => Column(
        spacing: 18,
        children: [
          SizedBox(
            height: 185,
            child: CupertinoTheme(
              data: CupertinoTheme.of(context).copyWith(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                showTimeSeparator: true,
                dateOrder: DatePickerDateOrder.ymd,
                initialDateTime: DateTime(1, 1, 1, time.hour, time.minute),
                use24hFormat: true,
                onDateTimeChanged: (final DateTime newDate) {
                  time = TimeOfDay(hour: newDate.hour, minute: newDate.minute);
                },
              ),
            ),
          ),
          Row(
            spacing: 10,
            children: [
              UElevatedButton(
                onTap: () => AppNavigator.back(),
                title: s.cancel,
                backgroundColor: context.theme.hintColor,
              ).expanded(),
              UElevatedButton(
                onTap: () {
                  setState(() {
                    currentValue = time;
                  });
                  state.didChange(time);
                  widget.onConfirm(timeStr, currentValue);
                  AppNavigator.back();
                },
                title: s.confirm,
              ).expanded(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return FormField<TimeOfDay?>(
      initialValue: currentValue,
      validator: (final value) {
        if (widget.required && value == null) {
          return s.requiredField;
        }
        return widget.validator?.call(timeStr);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (final formFieldState) => InkWell(
        onTap: () => _showTimePicker(formFieldState),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: widget.labelText != null
                ? '${widget.labelText}'
                      '${widget.required && (widget.showRequired ?? true) ? '*' : ''}'
                : null,
            labelStyle: context.textTheme.bodyMedium!.copyWith(
              fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2,
              color: context.theme.hintColor,
            ),
            floatingLabelStyle: context.textTheme.bodyLarge!,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            errorText: formFieldState.errorText,
            suffixIcon: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: UImage(AppIcons.clockOutline, color: context.theme.hintColor, size: 20),
            ),
          ),
          isEmpty: formFieldState.value == null,
          child: formFieldState.value == null
              ? const SizedBox.shrink()
              : Text(timeStr!).bodyMedium(fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2),
        ),
      ),
    );
  }
}
