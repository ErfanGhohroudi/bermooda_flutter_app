import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../data/data.dart';

class WorkshiftYearMonthHeader extends StatelessWidget {
  const WorkshiftYearMonthHeader({
    required this.years,
    required this.selectedYear,
    required this.months,
    required this.selectedMonth,
    required this.onYearChanged,
    required this.onMonthChanged,
    super.key,
  });

  final List<YearShiftReadDto> years;
  final YearShiftReadDto? selectedYear;

  final List<MonthShiftReadDto> months;
  final MonthShiftReadDto? selectedMonth;

  final void Function(YearShiftReadDto? year) onYearChanged;
  final void Function(MonthShiftReadDto? month) onMonthChanged;

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: WDropDownFormField<YearShiftReadDto>(
            labelText: s.year,
            value: selectedYear,
            items: years
                .map(
                  (final y) => DropdownMenuItem<YearShiftReadDto>(
                    value: y,
                    child: WDropdownItemText(text: y.year.toString()),
                  ),
                )
                .toList(),
            onChanged: onYearChanged,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: WDropDownFormField<MonthShiftReadDto>(
            labelText: s.month,
            value: selectedMonth,
            items: months
                .map(
                  (final m) => DropdownMenuItem<MonthShiftReadDto>(
                    value: m,
                    child: WDropdownItemText(text: m.monthNumber.getJalaliMonthNameFaEn()),
                  ),
                )
                .toList(),
            onChanged: onMonthChanged,
          ),
        ),
      ],
    );
  }
}


