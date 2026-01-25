import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';

/// Multi-select Jalali week days dropdown.
///
/// Values are Jalali weekDay integers:
/// - 1: Saturday
/// - 2: Sunday
/// - 3: Monday
/// - 4: Tuesday
/// - 5: Wednesday
/// - 6: Thursday
/// - 7: Friday
class DayOfWeekPicker extends StatefulWidget {
  const DayOfWeekPicker({
    required this.selectedWeekdays,
    required this.onChanged,
    this.enabled = true,
    this.selectAllByDefault = true,
    this.required = true,
    super.key,
  });

  final Set<int> selectedWeekdays;
  final ValueChanged<Set<int>> onChanged;
  final bool enabled;
  final bool selectAllByDefault;
  final bool required;

  @override
  State<DayOfWeekPicker> createState() => _DayOfWeekPickerState();
}

class _DayOfWeekPickerState extends State<DayOfWeekPicker> {
  late Set<int> _selectedWeekdays;

  static const _fa = [
    "شنبه",
    "یکشنبه",
    "دوشنبه",
    "سه\u200Cشنبه",
    "چهارشنبه",
    "پنجشنبه",
    "جمعه",
  ];
  static const _en = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];
  static const _allWeekdays = {1, 2, 3, 4, 5, 6, 7};

  @override
  void initState() {
    super.initState();
    _selectedWeekdays = widget.selectedWeekdays.isEmpty && widget.selectAllByDefault
        ? {..._allWeekdays}
        : {...widget.selectedWeekdays};
    if (_selectedWeekdays != widget.selectedWeekdays) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(_selectedWeekdays);
      });
    }
  }

  @override
  void didUpdateWidget(final DayOfWeekPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedWeekdays != oldWidget.selectedWeekdays) {
      _selectedWeekdays = {...widget.selectedWeekdays};
    }
  }

  void _toggleWeekday(final int weekDay) {
    if (!widget.enabled) return;
    setState(() {
      if (_selectedWeekdays.contains(weekDay)) {
        _selectedWeekdays.remove(weekDay);
      } else {
        _selectedWeekdays.add(weekDay);
      }
    });
    widget.onChanged(_selectedWeekdays);
  }

  void _showPickerDialog() {
    if (!widget.enabled) return;

    final labels = isPersianLang ? _fa : _en;

    bottomSheetWithNoScroll<void>(
      title: '${s.select} ${s.weekDays}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          StatefulBuilder(
            builder: (final context, final setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(_allWeekdays.length, (final index) {
                  final weekDay = index + 1;
                  final isSelected = _selectedWeekdays.contains(weekDay);
                  final title = labels[index];

                  return CheckboxListTile(
                    value: isSelected,
                    title: Text(title).bodyMedium(),
                    checkColor: Colors.white,
                    activeColor: AppColors.green,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    side: WidgetStateBorderSide.resolveWith(
                      (final states) {
                        if (states.contains(WidgetState.selected)) {
                          return const BorderSide(color: AppColors.green, width: 2);
                        }
                        return const BorderSide(
                          color: Colors.grey,
                          width: 2,
                        );
                      },
                    ),
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onChanged: (final value) => setState(() => _toggleWeekday(weekDay)),
                  );
                }),
              );
            },
          ),
          UElevatedButton(
            width: double.maxFinite,
            title: s.close,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final labels = isPersianLang ? _fa : _en;
    final selectedWeekdaysList = _selectedWeekdays.toList()..sort();

    return FormField(
      enabled: widget.enabled,
      validator: widget.required ? validateNotEmpty(requiredMessage: s.requiredField) : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (final formFieldState) => InkWell(
        onTap: _showPickerDialog,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: s.weekDays,
            labelStyle: context.textTheme.bodyMedium!.copyWith(
              fontSize: (context.textTheme.bodyMedium!.fontSize ?? 12) + 2,
              color: context.theme.hintColor,
            ),
            floatingLabelStyle: context.textTheme.bodyLarge!,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            errorText: formFieldState.errorText,
            suffixIcon: Container(
              margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
              child: const Icon(Icons.arrow_drop_down_rounded, size: 30),
            ),
          ),
          isEmpty: selectedWeekdaysList.isEmpty,
          child: Wrap(
            spacing: 4,
            children: selectedWeekdaysList.map((final weekDay) {
              final label = labels[weekDay - 1];
              return FilterChip(
                label: Text(label).bodyMedium(color: context.theme.primaryColor),
                selected: true,
                labelPadding: EdgeInsets.zero,
                onDeleted: widget.enabled ? () => _toggleWeekday(weekDay) : null,
                selectedColor: context.theme.primaryColor.withValues(alpha: 0.15),
                side: BorderSide(color: context.theme.primaryColor.withValues(alpha: 0.3)),
                deleteIcon: widget.enabled
                    ? Icon(
                        Icons.close,
                        size: 16,
                        color: context.theme.primaryColor,
                      )
                    : null,
                onSelected: (final value) {},
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
