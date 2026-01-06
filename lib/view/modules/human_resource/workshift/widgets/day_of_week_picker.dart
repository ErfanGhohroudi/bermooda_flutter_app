import 'package:u/utilities.dart';

import '../../../../../core/core.dart';

/// Multi-select Jalali week days.
///
/// Values are Jalali weekDay integers:
/// - 1: Saturday
/// - 2: Sunday
/// - 3: Monday
/// - 4: Tuesday
/// - 5: Wednesday
/// - 6: Thursday
/// - 7: Friday
class DayOfWeekPicker extends StatelessWidget {
  const DayOfWeekPicker({
    required this.selectedWeekdays,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final Set<int> selectedWeekdays;
  final ValueChanged<Set<int>> onChanged;
  final bool enabled;

  static const _fa = ["ش", "ی", "د", "س", "چ", "پ", "ج"];
  static const _en = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];

  @override
  Widget build(final BuildContext context) {
    final labels = isPersianLang ? _fa : _en;
    final primary = context.theme.primaryColor;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (final i) {
          final weekDay = i + 1;
          final isSelected = selectedWeekdays.contains(weekDay);
          return Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: i == 6 ? 0 : 6),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: enabled
                    ? () {
                        final next = {...selectedWeekdays};
                        if (isSelected) {
                          next.remove(weekDay);
                        } else {
                          next.add(weekDay);
                        }
                        onChanged(next);
                      }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isSelected ? primary.withAlpha(35) : context.theme.cardColor,
                    border: Border.all(
                      color: isSelected ? primary.withAlpha(130) : context.theme.dividerColor.withAlpha(90),
                    ),
                  ),
                  child: Center(
                    child: Text(labels[i])
                        .bodyMedium(
                          color: enabled ? null : context.theme.hintColor,
                        )
                        .bold(),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}


