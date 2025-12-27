part of 'fields.dart';

class WRangeDatePickerField extends StatefulWidget {
  const WRangeDatePickerField({
    required this.onConfirm,
    this.initialValue,
    this.startDate,
    this.labelText,
    this.enabled = true,
    this.required = false,

    /// set [false] if you want to hide [*] after [labelText]
    this.showRequired,
    this.showYearSelector = false,
    this.enableClearButton = true,
    super.key,
  });

  final Function(RangeDatePickerViewModel value) onConfirm;
  final RangeDatePickerViewModel? initialValue;
  final Jalali? startDate;
  final String? labelText;
  final bool enabled;
  final bool required;
  final bool? showRequired;
  final bool showYearSelector;
  final bool enableClearButton;

  @override
  State<WRangeDatePickerField> createState() => _WRangeDatePickerFieldState();
}

class _WRangeDatePickerFieldState extends State<WRangeDatePickerField> {
  RangeDatePickerViewModel? _currentData;
  final TextEditingController _dateController = TextEditingController();

  // List<String> _dataList = []; // [startDate, endDate, startTime, dueTime]

  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    _currentData = widget.initialValue?.copyWith();
    _setDateController();
  }

  void _setDateController() {
    _dateController.text = _currentData?.getString() ?? '';
  }

  // RangeDatePickerViewModel? _getCurrentDateData() {
  //   RangeDatePickerViewModel? date;
  //   final list = _dataList.where((final e) => e != '').toList();
  //   if (list.isNotEmpty) {
  //     date = RangeDatePickerViewModel(
  //       startDate: _dataList[0].isNotEmpty ? _dataList[0] : null,
  //       endDate: _dataList[1].isNotEmpty ? _dataList[1] : null,
  //       startTime: _dataList[2].isNotEmpty ? _dataList[2] : null,
  //       dueTime: _dataList[3].isNotEmpty ? _dataList[3] : null,
  //     );
  //   }
  //   return date;
  // }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WRangeDatePickerField oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      setState(() {
        _setInitialData();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return UTextFormField(
      enabled: widget.enabled,
      controller: _dateController,
      labelText: widget.labelText ?? s.date,
      required: widget.showRequired ?? widget.required,
      readOnly: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.required
          ? validateNotEmpty(
              requiredMessage: s.requiredField,
            )
          : null,
      onTap: () async {
        FocusManager.instance.primaryFocus!.unfocus();
        if (widget.enabled) {
          final hadInitialValue = _dateController.text.isNotEmpty;

          final result = await DateAndTimeFunctions.showCustomPersianRangDatePicker(
            startDate: widget.startDate,
            initialDate: _currentData,
            showYearSelector: widget.showYearSelector,
            barrierDismissible: false,
            enableClearButton: widget.enableClearButton,
          );
          FocusManager.instance.primaryFocus!.unfocus();
          if (result != null && result.startDate != null) {
            _currentData = result;
            _setDateController();
            widget.onConfirm(_currentData!);
          } else if (result != null && result.startDate == null && hadInitialValue && widget.enableClearButton) {
            // Handle clear button click - result is RangeDatePickerViewModel with null startDate when clear is pressed
            // Only clear if there was an initial value and clear button is enabled
            _currentData = null;
            _dateController.text = '';
            // Call onConfirm with RangeDatePickerViewModel - parent should handle RangeDatePickerViewModel with null values as cleared date
            widget.onConfirm(RangeDatePickerViewModel());
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

class RangeDatePickerViewModel extends Equatable {
  RangeDatePickerViewModel({
    this.startDate,
    this.endDate,
    this.startTime,
    this.dueTime,
  }) : assert(startDate == null || startDate.toJalali() != null, 'startDate format is not yyyy/mm/dd'),
       assert(endDate == null || endDate.toJalali() != null, 'endDate format is not yyyy/mm/dd'),
       assert(
         startTime == null || (startTime.split(':').length == 2 && startTime.split(':').join('').isNumericOnly),
         'startTime format is not hh:mm',
       ),
       assert(
         dueTime == null || (dueTime.split(':').length == 2 && dueTime.split(':').join('').isNumericOnly),
         'dueTime format is not hh:mm',
       );

  String? startDate; // yyyy/mm/dd
  String? endDate; // yyyy/mm/dd
  String? startTime; // hh:mm
  String? dueTime; // hh:mm

  RangeDatePickerViewModel copyWith({
    final String? startDate,
    final String? endDate,
    final String? startTime,
    final String? dueTime,
  }) => RangeDatePickerViewModel(
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    startTime: startTime ?? this.startTime,
    dueTime: dueTime ?? this.dueTime,
  );

  // این متد تمام منطق اعتبارسنجی را انجام می‌دهد.
  // یک پیام خطا برمی‌گرداند اگر نامعتبر باشد، و null اگر معتبر باشد.
  String? isValid() {
    // ۱. تبدیل رشته‌ها به اشیاء تاریخ و زمان قابل مقایسه
    final now = Jalali.now();
    Jalali? startDateTime;
    Jalali? endDateTime;

    if (dueTime != null && endDate == null && startDate != null) endDate = startDate;
    if (dueTime == null && endDate == startDate) endDate = null;

    if (startDate != null) {
      final dateParts = startDate!.split('/').map(int.parse).toList();
      final timeParts = startTime?.split(':').map(int.parse).toList() ?? [0, 0];
      startDateTime = Jalali(dateParts[0], dateParts[1], dateParts[2], timeParts[0], timeParts[1]);
    }

    if (endDate != null) {
      final dateParts = endDate!.split('/').map(int.parse).toList();
      final timeParts = dueTime?.split(':').map(int.parse).toList() ?? [23, 59];
      endDateTime = Jalali(dateParts[0], dateParts[1], dateParts[2], timeParts[0], timeParts[1]);
    }

    // ۲. شروع اعتبارسنجی‌ها

    // // شرط اول: تاریخ شروع نباید قبل از زمان حال باشد
    // if (startDateTime != null && startDateTime.isBefore(now)) {
    //   return 'تاریخ و زمان شروع نمی‌تواند در گذشته باشد.';
    // }

    // شرط دوم: تاریخ پایان نباید قبل از زمان حال باشد
    if (endDateTime != null && endDateTime.isBefore(now)) {
      return s.dueTimeMustBeSetInFuture;
    }

    // شرط سوم: تاریخ پایان نباید قبل از تاریخ شروع باشد
    if (startDateTime != null && endDateTime != null && endDateTime.isBefore(startDateTime)) {
      return s.dueTimeMustBeSetInFuture;
    }

    // اگر تمام شروط پاس شدند، هیچ خطایی وجود ندارد
    return null;
  }

  String getString() {
    String result = '';

    final dataList = [
      startDate ?? '',
      endDate ?? '',
      startTime ?? '',
      dueTime ?? '',
    ];
    final startList = [
      if (dataList[0].isNotEmpty) dataList[0],
      if (dataList[2].isNotEmpty) dataList[2],
    ];
    final dueList = [
      if (dataList[1].isNotEmpty) dataList[1],
      if (dataList[3].isNotEmpty) dataList[3],
    ];

    if (startDate != null && endDate != null && startTime != null && dueTime != null && startDate == endDate) {
      result = "$startDate   ${s.to}   $startTime - $dueTime";
    } else {
      result = startList.isNotEmpty && dueList.isNotEmpty
          ? "${startList.join(" ")}   ${s.to}   ${dueList.join(" ")}"
          : startList.join(" ");
    }

    return result;
  }

  @override
  List<Object?> get props => [startDate, startTime, endDate, dueTime];
}
