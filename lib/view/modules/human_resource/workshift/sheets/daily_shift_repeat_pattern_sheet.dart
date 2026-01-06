import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/functions/date_picker_functions.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/extensions/color_extension.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/widgets/fields/fields.dart';
import '../../../../../data/data.dart';
import '../enums/shift_flexible_time_duration.dart';
import '../widgets/monthly_days_picker.dart';
import '../create_update/models/daily_shift_repeat_pattern.dart';
import '../widgets/day_of_week_picker.dart';

class DailyShiftRepeatPatternSheet extends StatefulWidget {
  const DailyShiftRepeatPatternSheet({
    super.key,
    this.initialPattern,
    this.enableOnlyThisDayRepeatType = false,
  });

  final DailyShiftRepeatPattern? initialPattern;
  final bool enableOnlyThisDayRepeatType;

  @override
  State<DailyShiftRepeatPatternSheet> createState() => _DailyShiftRepeatPatternSheetState();
}

class _DailyShiftRepeatPatternSheetState extends State<DailyShiftRepeatPatternSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final ScrollController _scrollCtrl;
  late LabelColors _selectedColor;
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
  Set<int> _weekdays = {1, 2, 3, 4, 5}; // weekly: default Sat..Wed
  Set<int> _monthlyDays = <int>{};

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
      _titleCtrl = TextEditingController(text: pattern.shiftTypeParams.title);
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
    } else {
      _titleCtrl = TextEditingController();
      _selectedColor = LabelColors.values.first;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final times = DateAndTimeFunctions.generateTimeSlots();
    return UScaffold(
      bottomNavigationBar: UElevatedButton(
        title: s.next,
        width: double.maxFinite,
        onTap: _submit,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        controller: _scrollCtrl,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WTextField(
                controller: _titleCtrl,
                labelText: isPersianLang ? 'عنوان شیفت' : 'Shift title',
                required: true,
                showRequired: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 18),
              WDropDownFormField<LabelColors>(
                labelText: isPersianLang ? 'رنگ شیفت' : 'Shift color',
                value: _selectedColor,
                required: true,
                showRequiredIcon: false,
                items: LabelColors.values
                    .map(
                      (final LabelColors value) => DropdownMenuItem<LabelColors>(
                        value: value,
                        child: Row(
                          spacing: 10,
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: value.colorCode.toColor(),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            WDropdownItemText(text: value.getTitle()),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (final value) {
                  if (value == null) return;
                  _selectedColor = value;
                },
              ),
              const SizedBox(height: 18),
              WDropDownFormField<String>(
                labelText: isPersianLang ? 'زمان ورود' : 'Entry time',
                required: true,
                value: _startTime,
                items: getDropDownMenuItemsFromString(menuItems: times),
                onChanged: (final v) => setState(() => _startTime = v),
              ),
              const SizedBox(height: 18),
              WDropDownFormField<String>(
                labelText: isPersianLang ? 'زمان خروج' : 'Exit time',
                required: true,
                value: _endTime,
                items: getDropDownMenuItemsFromString(menuItems: times),
                onChanged: (final v) => setState(() => _endTime = v),
              ),
              const SizedBox(height: 18),
              WSwitchForm(
                value: _isNightShift,
                icon: AppIcons.moonOutline,
                title: isPersianLang ? 'شیفت شب' : 'Night shift',
                onChanged: () {},
              ),
              const SizedBox(height: 4),
              Text(
                isPersianLang
                    ? 'شیفتهایی که از شب یک روز شروع شده و صبح روز بعد تمام میشوند (مثلاً ۲۲:۰۰ - ۰۶:۰۰)'
                    : 'Shifts that start one night and end the next morning (e.g., 22:00 - 06:00)',
              ).bodySmall(color: context.theme.hintColor),
              const SizedBox(height: 12),
              Text(s.breakText).titleMedium(color: context.theme.hintColor),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: WDropDownFormField<String>(
                      labelText: s.start,
                      value: _breakStartTime,
                      items: getDropDownMenuItemsFromString(menuItems: times),
                      onChanged: (final v) => setState(() => _breakStartTime = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: WDropDownFormField<String>(
                      labelText: s.end,
                      value: _breakEndTime,
                      items: getDropDownMenuItemsFromString(menuItems: times),
                      onChanged: (final v) => setState(() => _breakEndTime = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(isPersianLang ? 'زمان شناور' : 'Floating time').titleMedium(color: context.theme.hintColor),
              const SizedBox(height: 10),
              Row(
                spacing: 10,
                children: [
                  WDropDownFormField<ShiftFlexibleTimeDuration>(
                    labelText: isPersianLang ? 'ورود' : 'Entry',
                    required: false,
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
                    labelText: isPersianLang ? 'خروج' : 'Exit',
                    required: false,
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
                labelText: isPersianLang ? 'روش‌های مجاز ثبت تردد' : 'Allowed attendance methods',
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
              const SizedBox(height: 18),

              // ----------------------------------------------------------------
              // Repeat options
              // ----------------------------------------------------------------
              Text(isPersianLang ? 'گزینه‌های تکرار' : 'Repeat options').titleMedium(color: context.theme.hintColor),
              const SizedBox(height: 10),
              WDropDownFormField<WorkshiftRepeatType>(
                labelText: isPersianLang ? 'نوع تکرار' : 'Repeat type',
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
                Text(
                  isPersianLang
                      ? 'شیفت در روزهای انتخابی تا پایان سال (سال انتخاب شده) ایجاد می‌شود'
                      : 'Shifts will be created on selected weekdays until end of selected year',
                ).bodySmall(color: context.theme.hintColor),
                const SizedBox(height: 10),
                DayOfWeekPicker(
                  selectedWeekdays: _weekdays,
                  onChanged: (final next) => setState(() => _weekdays = next),
                ),
              ],
              if (_repeatType == WorkshiftRepeatType.monthly) ...[
                Text(
                  isPersianLang
                      ? 'شیفت در روزهای انتخابی تمام ماه‌های باقیمانده سال (سال انتخاب شده) ایجاد می‌شود'
                      : 'Shifts will be created on selected month days for remaining months of selected year',
                ).bodySmall(color: context.theme.hintColor),
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
      ),
    );
  }

  void _submit() {
    validateForm(
      key: _formKey,
      action: () {
        if (_startTime == null || _endTime == null) {
          return AppNavigator.snackbarRed(title: s.error, subtitle: s.requiredField);
        }
        if ((_breakStartTime == null) != (_breakEndTime == null)) {
          return AppNavigator.snackbarRed(
            title: s.error,
            subtitle: isPersianLang ? 'شروع و پایان استراحت باید هر دو مشخص شوند' : 'Break start/end must both be set',
          );
        }
        if (_breakStartTime != null &&
            _breakEndTime != null &&
            _breakStartTime!.numericOnly().toInt() >= _breakEndTime!.numericOnly().toInt()) {
          return AppNavigator.snackbarRed(
            title: s.error,
            subtitle: isPersianLang ? 'پایان استراحت باید بیشتر از شروع استراحت باشد' : 'Break start must be after break end',
          );
        }
        if (_allowedMethod == null) {
          return AppNavigator.snackbarRed(
            title: s.error,
            subtitle: isPersianLang ? 'حداقل یک روش برای ثبت تردد انتخاب کنید' : 'Pick at least one attendance method',
          );
        }
        if (_repeatType == WorkshiftRepeatType.weekly && _weekdays.isEmpty) {
          return AppNavigator.snackbarRed(
            title: s.error,
            subtitle: isPersianLang ? 'حداقل یک روز هفته را انتخاب کنید' : 'Pick at least one weekday',
          );
        }
        if (_repeatType == WorkshiftRepeatType.monthly && _monthlyDays.isEmpty) {
          return AppNavigator.snackbarRed(
            title: s.error,
            subtitle: isPersianLang ? 'حداقل یک روز ماه را انتخاب کنید' : 'Pick at least one day of month',
          );
        }
        final title = _titleCtrl.text.trim();
        if (title.isEmpty) {
          return AppNavigator.snackbarRed(title: s.error, subtitle: s.requiredField);
        }

        final shiftTypeParams = ShiftTypeParams(
          title: title,
          startTime: _startTime!,
          endTime: _endTime!,
          color: _selectedColor,
          breakStartTime: _breakStartTime,
          breakEndTime: _breakEndTime,
          flexibleStartTime: _flexibleStartTime,
          flexibleEndTime: _flexibleEndTime,
          allowedCheckInMethodList: <AttendanceMethod>[_allowedMethod!],
          allowedCheckOutMethodList: <AttendanceMethod>[_allowedMethod!],
        );

        Navigator.of(context).pop(
          DailyShiftRepeatPattern(
            shiftTypeParams: shiftTypeParams,
            repeatType: _repeatType,
            weeklySelectedWeekdays: _repeatType == WorkshiftRepeatType.weekly ? _weekdays : <int>{},
            monthlySelectedDays: _repeatType == WorkshiftRepeatType.monthly ? _monthlyDays : <int>{},
          ),
        );
      },
    );
  }
}
