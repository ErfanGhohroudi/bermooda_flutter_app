import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/functions/date_picker_functions.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../enums/shift_flexible_time_duration.dart';
import '../enums/workshift_repeat_type.dart';
import '../widgets/monthly_days_picker.dart';
import '../create_update/models/daily_shift_repeat_pattern.dart';
import '../widgets/day_of_week_picker.dart';

class DailyShiftRepeatPatternSheet extends StatefulWidget {
  const DailyShiftRepeatPatternSheet({
    super.key,
    this.initialPattern,
    this.enableOnlyThisDayRepeatType = false,
    this.isInitialSetup = false,
  });

  final DailyShiftRepeatPattern? initialPattern;
  final bool enableOnlyThisDayRepeatType;
  final bool isInitialSetup;

  @override
  State<DailyShiftRepeatPatternSheet> createState() => _DailyShiftRepeatPatternSheetState();
}

class _DailyShiftRepeatPatternSheetState extends State<DailyShiftRepeatPatternSheet> {
  final _formKey = GlobalKey<FormState>();
  late final ScrollController _scrollCtrl;
  LabelColors? _selectedColor;
  String? _startTime;
  String? _endTime;
  String? _breakStartTime;
  String? _breakEndTime;
  ShiftFlexibleTimeDuration? _flexibleStartTime;
  ShiftFlexibleTimeDuration? _flexibleEndTime;
  AttendanceMethod? _allowedMethod;

  // Repeat options
  late WorkshiftRepeatType _repeatType;
  late final List<WorkshiftRepeatType> _repeatTypeItems;
  Set<int> _weekdays = <int>{};
  Set<int> _monthlyDays = <int>{};

  // Cached values for performance optimization
  late final List<DropdownMenuItem<String>> _timeDropdownItems;

  String get _workshiftTitle => [_startTime, _endTime].whereType<String>().join(' - ');

  LabelColors get _getSelectedColor => _selectedColor ?? LabelColors.getRandom();

  bool get _isNightShift =>
      _startTime != null && _endTime != null && _endTime!.numericOnly().toInt() <= _startTime!.numericOnly().toInt();

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    _repeatTypeItems = widget.enableOnlyThisDayRepeatType
        ? WorkshiftRepeatType.values
        : WorkshiftRepeatType.values.whereNot((final e) => e == WorkshiftRepeatType.singleDay).toList();
    _repeatType = _repeatTypeItems.first;

    final pattern = widget.initialPattern;
    if (pattern != null) {
      _selectedColor = pattern.shiftTypeParams.color;
      _startTime = pattern.shiftTypeParams.startTime;
      _endTime = pattern.shiftTypeParams.endTime;
      _breakStartTime = pattern.shiftTypeParams.breakStartTime;
      _breakEndTime = pattern.shiftTypeParams.breakEndTime;
      _flexibleStartTime = pattern.shiftTypeParams.flexibleStartTime;
      _flexibleEndTime = pattern.shiftTypeParams.flexibleEndTime;
      _allowedMethod = pattern.shiftTypeParams.allowedCheckInMethodList.isNotEmpty
          ? pattern.shiftTypeParams.allowedCheckInMethodList.first
          : null;
      if (widget.enableOnlyThisDayRepeatType ||
          (widget.enableOnlyThisDayRepeatType == false && pattern.repeatType != WorkshiftRepeatType.singleDay)) {
        _repeatType = pattern.repeatType;
      }
      _weekdays = pattern.weeklySelectedWeekdays;
      _monthlyDays = pattern.monthlySelectedDays;
    }

    // Cache محاسبات سنگین برای بهینه‌سازی عملکرد
    final times = DateAndTimeFunctions.generateTimeSlots();
    _timeDropdownItems = getDropDownMenuItemsFromString(menuItems: times);
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      bottomNavigationBar: UElevatedButton(
        title: widget.isInitialSetup ? s.next : s.addText,
        width: double.maxFinite,
        onTap: _submit,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        controller: _scrollCtrl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      WDropDownFormField<String>(
                        labelText: s.entryTime,
                        required: true,
                        value: _startTime,
                        items: _timeDropdownItems,
                        onChanged: (final v) => setState(() => _startTime = v),
                      ).expanded(),
                      WDropDownFormField<String>(
                        labelText: s.exitTime,
                        required: true,
                        value: _endTime,
                        items: _timeDropdownItems,
                        onChanged: (final v) => setState(() => _endTime = v),
                      ).expanded(),
                    ],
                  ),
                  const SizedBox(height: 18),
                  WSwitchForm(
                    value: _isNightShift,
                    icon: AppIcons.moonOutline,
                    title: s.nightShift,
                    onChanged: () {},
                  ),
                  const SizedBox(height: 4),
                  Text(s.nightShiftHelper).bodySmall(color: context.theme.hintColor),
                  const SizedBox(height: 12),
                  Text(s.breakText).titleMedium(color: context.theme.hintColor),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: WDropDownFormField<String>(
                          labelText: s.start,
                          value: _breakStartTime,
                          required: _breakEndTime != null,
                          items: _timeDropdownItems,
                          onChanged: (final v) => setState(() => _breakStartTime = v),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: WDropDownFormField<String>(
                          labelText: s.end,
                          value: _breakEndTime,
                          required: _breakStartTime != null,
                          items: _timeDropdownItems,
                          onChanged: (final v) => setState(() => _breakEndTime = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(s.floatingTime).titleMedium(color: context.theme.hintColor),
                  const SizedBox(height: 10),
                  Row(
                    spacing: 10,
                    children: [
                      WDropDownFormField<ShiftFlexibleTimeDuration>(
                        labelText: s.entry,
                        value: _flexibleStartTime,
                        items: ShiftFlexibleTimeDuration.values
                            .map(
                              (final option) => DropdownMenuItem<ShiftFlexibleTimeDuration>(
                            value: option,
                            child: WDropdownItemText(
                              text: option.title,
                            ),
                          ),
                        )
                            .toList(),
                        onChanged: (final v) => _flexibleStartTime = v,
                      ).expanded(),
                      WDropDownFormField<ShiftFlexibleTimeDuration>(
                        labelText: s.exit,
                        value: _flexibleEndTime,
                        items: ShiftFlexibleTimeDuration.values
                            .map(
                              (final option) => DropdownMenuItem<ShiftFlexibleTimeDuration>(
                            value: option,
                            child: WDropdownItemText(
                              text: option.title,
                            ),
                          ),
                        )
                            .toList(),
                        onChanged: (final v) => _flexibleEndTime = v,
                      ).expanded(),
                    ],
                  ),
                  const SizedBox(height: 32),
                  WDropDownFormField<AttendanceMethod>(
                    labelText: s.allowedAttendanceMethods,
                    value: _allowedMethod,
                    required: true,
                    showRequiredIcon: false,
                    items: AttendanceMethod.values
                        .map(
                          (final m) => DropdownMenuItem<AttendanceMethod>(
                        value: m,
                        child: WDropdownItemText(text: m.title),
                      ),
                    )
                        .toList(),
                    onChanged: (final v) => setState(() => _allowedMethod = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // ----------------------------------------------------------------
            // Repeat options
            // ----------------------------------------------------------------
            Text(s.repeatOptions).titleMedium(color: context.theme.hintColor),
            const SizedBox(height: 10),
            WDropDownFormField<WorkshiftRepeatType>(
              labelText: s.repeatType,
              value: _repeatType,
              required: true,
              showRequiredIcon: false,
              items: _repeatTypeItems
                  .map(
                    (final t) => DropdownMenuItem<WorkshiftRepeatType>(
                      value: t,
                      child: WDropdownItemText(text: t.title),
                    ),
                  )
                  .toList(),
              onChanged: (final v) {
                if (v == null) return;
                setState(() => _repeatType = v);
                if (_repeatType != WorkshiftRepeatType.singleDay) {
                  _scrollCtrl.animateTo(
                    _scrollCtrl.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            if (_repeatType == WorkshiftRepeatType.weekly) ...[
              Text(s.weeklyRepeatTypeHelper).bodySmall(color: context.theme.hintColor),
              const SizedBox(height: 10),
              DayOfWeekPicker(
                selectedWeekdays: _weekdays,
                onChanged: (final next) => setState(() => _weekdays = next),
              ),
            ],
            if (_repeatType == WorkshiftRepeatType.monthly) ...[
              Text(s.monthlyRepeatTypeHelper).bodySmall(color: context.theme.hintColor),
              const SizedBox(height: 10),
              MonthlyDaysPicker(
                selectedDays: _monthlyDays,
                onChanged: (final next) => setState(() => _monthlyDays = next),
              ),
            ],
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  /// اعتبارسنجی تمام فیلدهای فرم
  /// Returns null if validation passes, otherwise returns error message
  String? _validateFormData() {
    if (_startTime == null || _endTime == null) {
      return s.requiredField;
    }
    if ((_breakStartTime == null) != (_breakEndTime == null)) {
      return s.breakStartEndMustBothBeSet;
    }
    if (_allowedMethod == null) {
      return s.pickAtLeastOneAttendanceMethod;
    }
    if (_repeatType == WorkshiftRepeatType.weekly && _weekdays.isEmpty) {
      return s.pickAtLeastOneWeekday;
    }
    if (_repeatType == WorkshiftRepeatType.monthly && _monthlyDays.isEmpty) {
      return s.pickAtLeastOneDayOfMonth;
    }
    return null; // اعتبارسنجی موفق
  }

  /// ساخت ShiftTypeParams از داده‌های فرم
  ShiftTypeParams _buildShiftTypeParams() {
    return ShiftTypeParams(
      title: _workshiftTitle,
      startTime: _startTime!,
      endTime: _endTime!,
      color: _getSelectedColor,
      breakStartTime: _breakStartTime,
      breakEndTime: _breakEndTime,
      flexibleStartTime: _flexibleStartTime,
      flexibleEndTime: _flexibleEndTime,
      allowedCheckInMethodList: <AttendanceMethod>[_allowedMethod!],
      allowedCheckOutMethodList: <AttendanceMethod>[_allowedMethod!],
    );
  }

  /// ساخت DailyShiftRepeatPattern از داده‌های فرم
  DailyShiftRepeatPattern _buildDailyShiftRepeatPattern(final ShiftTypeParams shiftTypeParams) {
    return DailyShiftRepeatPattern(
      shiftTypeParams: shiftTypeParams,
      repeatType: _repeatType,
      weeklySelectedWeekdays: _repeatType == WorkshiftRepeatType.weekly ? _weekdays : <int>{},
      monthlySelectedDays: _repeatType == WorkshiftRepeatType.monthly ? _monthlyDays : <int>{},
    );
  }

  /// متد اصلی submit - فقط هماهنگی بین اعتبارسنجی، ساخت مدل و ناوبری
  void _submit() {
    // validateForm(
    //   key: _formKey,
    //   action: () {
    final isValid = _formKey.currentState!.validate();
    if (isValid == false) return;
    // اعتبارسنجی داده‌ها
    final validationError = _validateFormData();
    if (validationError != null) {
      AppSnackBar.snackbarRed(title: s.error, subtitle: validationError);
      return;
    }

    // ساخت مدل‌ها
    final shiftTypeParams = _buildShiftTypeParams();
    final pattern = _buildDailyShiftRepeatPattern(shiftTypeParams);

    // ناوبری
    Navigator.of(context).pop(pattern);
    //   },
    // );
  }
}
