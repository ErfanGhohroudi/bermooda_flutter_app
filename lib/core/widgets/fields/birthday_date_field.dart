part of 'fields.dart';

class WBirthdayDateField extends StatefulWidget {
  WBirthdayDateField({
    required this.onChanged,
    this.initialCompactFormatterJalaliDate, // yyyy/mm/dd
    this.required,
    this.enable = true,
    super.key,
  }) : assert(initialCompactFormatterJalaliDate != null ? initialCompactFormatterJalaliDate.toJalali() != null : true, 'Date formatter is not yyyy/mm/dd');

  final String? initialCompactFormatterJalaliDate;
  final bool? required;
  final bool enable;
  final Function(String date) onChanged;

  @override
  State<WBirthdayDateField> createState() => _WBirthdayDateFieldState();
}

class _WBirthdayDateFieldState extends State<WBirthdayDateField> {
  int? selectedYear;
  int? selectedMonth;
  int? selectedDay;

  String _getBirthdayDate() => Jalali(
        selectedYear ?? Jalali.now().year,
        selectedMonth ?? Jalali.now().month,
        selectedDay ?? Jalali.now().day,
      ).formatCompactDate();

  @override
  void initState() {
    if (widget.initialCompactFormatterJalaliDate != null) {
      final date = widget.initialCompactFormatterJalaliDate!.split('/');
      selectedYear = date[0].toInt();
      selectedMonth = date[1].toInt();
      selectedDay = date[2].toInt();
    }
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.required ?? false ? '${s.dateOfBirth}*' : s.dateOfBirth).bodyMedium(fontSize: context.textTheme.bodyMedium!.fontSize! + 2, color: context.theme.hintColor).marginOnly(bottom: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WDropDownFormField<int>(
              enable: widget.enable,
              labelText: s.day,
              value: selectedDay,
              showRequiredIcon: false,
              required: widget.required ?? selectedMonth != null || selectedYear != null,
              items: List.generate(
                Jalali(selectedYear ?? DateTime.now().toJalali().year, selectedMonth ?? 1).monthLength,
                (final index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: WDropdownItemText(text:'${index + 1}'),
                  );
                },
              ),
              onChanged: (final value) {
                setState(() {
                  selectedDay = value;
                });
                widget.onChanged(_getBirthdayDate());
              },
            ).expanded(),
            const SizedBox(width: 10),
            WDropDownFormField<int>(
              enable: widget.enable,
              labelText: s.month,
              value: selectedMonth,
              showRequiredIcon: false,
              required: widget.required ?? selectedDay != null || selectedYear != null,
              items: List.generate(12, (final index) {
                return DropdownMenuItem(
                  value: index + 1,
                  child: WDropdownItemText(text: Jalali(selectedYear ?? DateTime.now().toJalali().year, index + 1).formatter.m),
                );
              }),
              onChanged: (final value) {
                setState(() {
                  selectedMonth = value;
                });
                widget.onChanged(_getBirthdayDate());
              },
            ).expanded(),
            const SizedBox(width: 10),
            WDropDownFormField<int>(
              enable: widget.enable,
              labelText: s.year,
              value: selectedYear,
              showRequiredIcon: false,
              required: widget.required ?? selectedMonth != null || selectedDay != null,
              items: List.generate(100, (final index) {
                int year = Jalali.now().year - index; // آخرین 100 سال
                return DropdownMenuItem(
                  value: year,
                  child: WDropdownItemText(text: '$year'),
                );
              }),
              onChanged: (final value) {
                setState(() {
                  selectedYear = value;
                });
                widget.onChanged(_getBirthdayDate());
              },
            ).expanded(),
          ],
        ),
      ],
    );
  }
}
