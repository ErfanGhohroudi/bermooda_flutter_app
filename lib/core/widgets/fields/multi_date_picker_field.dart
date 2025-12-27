import 'package:u/utilities.dart';

import '../../core.dart';
import '../../navigator/navigator.dart';
import 'fields.dart';

class WMultiDatePickerField extends StatefulWidget {
  const WMultiDatePickerField({
    required this.onChanged,
    this.startDate,
    this.labelText,
    this.initialDates = const [],
    this.required = false,
    this.showYearSelector = false,
    super.key,
  });

  final List<Jalali> initialDates;
  final Jalali? startDate;
  final String? labelText;
  final ValueChanged<List<Jalali>> onChanged;
  final bool required;
  final bool showYearSelector;

  @override
  State<WMultiDatePickerField> createState() => _WMultiDatePickerFieldState();
}

class _WMultiDatePickerFieldState extends State<WMultiDatePickerField> {
  // لیستی برای نگهداری تاریخ‌های انتخاب شده
  late final List<Jalali> _selectedDates;

  Key _textFieldKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    // مقداردهی اولیه لیست با تاریخ‌های ورودی
    _selectedDates = List.from(widget.initialDates);
    // مرتب‌سازی اولیه
    _selectedDates.sort();
  }

  /// تابع برای حذف یک تاریخ
  void _removeDate(final Jalali dateToRemove) {
    setState(() {
      _selectedDates.remove(dateToRemove);
    });
    // اطلاع‌رسانی به ویجت والد
    widget.onChanged(_selectedDates);
  }

  /// تابع برای افزودن یک تاریخ جدید
  Future<void> _addDate(final Jalali? date) async {
    if (date != null) {
      // جلوگیری از افزودن تاریخ تکراری
      if (!_selectedDates.contains(date)) {
        setState(() {
          _selectedDates.add(date);
          _selectedDates.sort();
          _textFieldKey = UniqueKey();
        });
        widget.onChanged(_selectedDates);
      } else {
        setState(() {
          _textFieldKey = UniqueKey();
        });
        AppNavigator.snackbarRed(title: s.error, subtitle: s.thisDateHasAlreadyBeenAdded);
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        WDatePickerField(
          key: _textFieldKey,
          labelText: widget.labelText,
          showYearSelector: widget.showYearSelector,
          startDate: widget.startDate,
          validator: widget.required
              ? (final value) {
                  if (_selectedDates.isEmpty) return s.requiredField;
                  return null;
                }
              : null,
          onConfirm: (final date, final compactFormatterDate) {
            _addDate(date);
          },
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: _selectedDates
              .map(
                (final date) => FilterChip(
                  label: Text(date.formatCompactDate()).bodyMedium(),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => _removeDate(date),
                  onSelected: (final value) {},
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
