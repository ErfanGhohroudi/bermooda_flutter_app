import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';

class MonthlyDaysPicker extends StatelessWidget {
  const MonthlyDaysPicker({
    required this.selectedDays,
    required this.onChanged,
    super.key,
  });

  final Set<int> selectedDays;
  final ValueChanged<Set<int>> onChanged;

  @override
  Widget build(final BuildContext context) {
    return GridView.builder(
      itemCount: 31,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (final context, final index) {
        final day = index + 1;
        final isSelected = selectedDays.contains(day);

        return WCard(
          onTap: () {
            final v = !isSelected;
            final next = {...selectedDays};
            if (v) {
              next.add(day);
            } else {
              next.remove(day);
            }
            onChanged(next);
          },
          showBorder: !isSelected,
          padding: 0,
          margin: EdgeInsets.zero,
          color: isSelected ? context.theme.primaryColor : null,
          child: Center(
            child: Text(day.toString()).titleMedium(color: isSelected ? Colors.white : null),
          ),
        );
      },
    );
  }
}
