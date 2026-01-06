import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../data/data.dart';

enum NightShiftSegment { start, end }

/// UI marker for a night shift that spans into the next day.
class NightShiftSpan extends StatelessWidget {
  const NightShiftSpan({
    required this.shiftType,
    required this.segment,
    super.key,
  });

  final ShiftTypeReadDto shiftType;
  final NightShiftSegment segment;

  @override
  Widget build(final BuildContext context) {
    final color = (shiftType.color?.color ?? context.theme.primaryColor);
    final label = switch (segment) {
      NightShiftSegment.start => '${shiftType.startTime} →',
      NightShiftSegment.end => '← ${shiftType.endTime}',
    };

    final borderRadius = switch (segment) {
      // No rounded edge on the side that visually connects to the adjacent day.
      NightShiftSegment.start =>
        isPersianLang
            ? const BorderRadius.horizontal(right: Radius.circular(10))
            : const BorderRadius.horizontal(left: Radius.circular(10)),
      NightShiftSegment.end =>
        isPersianLang
            ? const BorderRadius.horizontal(left: Radius.circular(10))
            : const BorderRadius.horizontal(right: Radius.circular(10)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withAlpha(35),
        borderRadius: borderRadius,
        border: Border.all(color: color.withAlpha(120)),
      ),
      child: Text(label).bodySmall(fontSize: 8, color: color).bold(),
    );
  }
}


