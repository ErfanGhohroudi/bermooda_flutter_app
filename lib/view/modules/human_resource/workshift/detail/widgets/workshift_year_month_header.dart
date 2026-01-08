import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../data/data.dart';

class WorkshiftYearMonthHeader extends StatelessWidget {
  const WorkshiftYearMonthHeader({
    required this.selectedMonth,
    required this.onYearChanged,
    required this.onMonthChanged,
    super.key,
  });

  final Jalali selectedMonth;

  final void Function(int year) onYearChanged;
  final void Function(int month) onMonthChanged;

  static const List<String> _monthNamesFa = [
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  static const List<String> _monthNamesEn = [
    'Farvardin',
    'Ordibehesht',
    'Khordad',
    'Tir',
    'Mordaad',
    'Shahrivar',
    'Mehr',
    'Aabaan',
    'Aazar',
    'Dey',
    'Bahman',
    'Esfand',
  ];

  String _getMonthName(final int number) => isPersianLang ? _monthNamesFa[number] : _monthNamesEn[number];

  List<int> get years {
    final nowYear = Jalali.now().year;
    List<int> years = [];
    for (int i = nowYear - 50; i <= nowYear + 50; i++) {
      years.add(i);
    }
    return years;
  }

  @override
  Widget build(final BuildContext context) {
    final selectedYear = this.selectedMonth.year;
    final selectedMonth = this.selectedMonth.month;

    return Row(
      children: [
        Expanded(
          child: WDropDownFormField<int>(
            labelText: s.year,
            value: selectedYear,
            items: years
                .map(
                  (final y) => DropdownMenuItem<int>(
                    value: y,
                    child: WDropdownItemText(text: y.toString()),
                  ),
                )
                .toList(),
            onChanged: (final value) {
              if (value == null) return;
              onYearChanged(value);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: WDropDownFormField<int>(
            labelText: s.month,
            value: selectedMonth,
            items: List<DropdownMenuItem<int>>.generate(12, (final index) {
              final m = index + 1;
              return DropdownMenuItem<int>(
                value: m,
                child: WDropdownItemText(text: _getMonthName(index)),
              );
            }),
            onChanged: (final value) {
              if (value == null) return;
              onMonthChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
