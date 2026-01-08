import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';

class MonthlyDaysPicker extends StatefulWidget {
  const MonthlyDaysPicker({
    required this.selectedDays,
    required this.onChanged,
    this.enabled = true,
    this.selectAllByDefault = true,
    this.required = true,
    super.key,
  });

  final Set<int> selectedDays;
  final ValueChanged<Set<int>> onChanged;
  final bool enabled;
  final bool selectAllByDefault;
  final bool required;

  @override
  State<MonthlyDaysPicker> createState() => _MonthlyDaysPickerState();
}

class _MonthlyDaysPickerState extends State<MonthlyDaysPicker> {
  late Set<int> _selectedDays;

  static const _allDays = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31};

  @override
  void initState() {
    super.initState();
    _selectedDays = widget.selectedDays.isEmpty && widget.selectAllByDefault
        ? {..._allDays}
        : {...widget.selectedDays};
    if (_selectedDays != widget.selectedDays) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(_selectedDays);
      });
    }
  }

  @override
  void didUpdateWidget(final MonthlyDaysPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDays != oldWidget.selectedDays) {
      _selectedDays = {...widget.selectedDays};
    }
  }

  void _toggleDay(final int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
    widget.onChanged(_selectedDays);
  }

  void _showPickerDialog() {
    bottomSheetWithNoScroll(
      title: '${s.select} ${s.daysOfMonth}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 18),
              child: StatefulBuilder(
                builder: (final context, final setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List<Widget>.generate(31, (final index) {
                      final day = index + 1;
                      final isSelected = _selectedDays.contains(day);
                      final title = day.toString();

                      return CheckboxListTile(
                        value: isSelected,
                        title: Text(title).titleMedium(),
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
                        onChanged: (final value) => setState(() => _toggleDay(day)),
                      );
                    }),
                  );
                },
              ),
            ),
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
    final selectedDaysList = _selectedDays.toList()..sort();

    return FormField(
      enabled: widget.enabled,
      validator: widget.required ? validateNotEmpty(requiredMessage: s.requiredField) : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (final formFieldState) => InkWell(
        onTap: _showPickerDialog,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: s.daysOfMonth,
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
          isEmpty: selectedDaysList.isEmpty,
          child: Wrap(
            spacing: 4,
            children: selectedDaysList.map((final day) {
              final label = day.toString();
              return FilterChip(
                label: Text(label).titleMedium(color: context.theme.primaryColor),
                selected: true,
                labelPadding: EdgeInsets.zero,
                onDeleted: widget.enabled ? () => _toggleDay(day) : null,
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
