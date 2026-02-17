import 'package:u/utilities.dart';

import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../data/data.dart';
import 'night_shift_span.dart';

/// Month calendar for Jalali dates.
///
/// Keys for [assignmentsByDate] are expected to be `yyyy-MM-dd` (Jalali).
class WorkshiftMonthCalendar extends StatelessWidget {
  const WorkshiftMonthCalendar({
    required this.month,
    required this.assignmentsByDate,
    required this.shiftTypeRegistry,
    required this.onDayTap,
    super.key,
  });

  final Jalali month; // must be day=1
  final RxMap<String, Set<String>> assignmentsByDate;
  final RxMap<String, ShiftTypeReadDto> shiftTypeRegistry;
  final void Function(Jalali day) onDayTap;

  int get _firstWeekDay => month.withDay(1).weekDay - 1;

  int get _monthLength => month.monthLength;

  @override
  Widget build(final BuildContext context) {
    final persianWeekDays = const ["ش", "ی", "د", "س", "چ", "پ", "ج"];
    final englishWeekDays = const ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];

    return SingleChildScrollView(
      child: Column(
        children: [
          /// WeakDays
          Container(
            height: 25,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: (isPersianLang ? persianWeekDays : englishWeekDays).map((final d) => Text(d).bodySmall()).toList(),
            ),
          ),
          const SizedBox(height: 6),

          /// Calendar
          Obx(
            () {
              /// Don't remove this line. it is for pass the Obx Error.
              if (assignmentsByDate.isEmpty || shiftTypeRegistry.isEmpty) {}

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 1,
                ),
                itemCount: _monthLength + _firstWeekDay,
                itemBuilder: (final context, final index) {
                  if (index < _firstWeekDay) return const SizedBox.shrink();

                  final day = index - _firstWeekDay + 1;
                  final dayDate = month.withDay(day);
                  final dayKey = _dayKey(dayDate);

                  final slugs = assignmentsByDate[dayKey] ?? const <String>{};
                  final chips = _buildChips(context, slugs);
                  final previousDaySlugs = day > 1
                      ? (assignmentsByDate[_dayKey(month.withDay(day - 1))] ?? const <String>{})
                      : const <String>{};

                  return _DayCell(
                    day: day,
                    chips: chips,
                    nightShiftSpans: _buildNightShiftSpans(
                      day: dayDate,
                      todaySlugs: slugs,
                      yesterdaySlugs: previousDaySlugs,
                    ),
                    onTap: () => onDayTap(dayDate),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 18),

          /// Calendar info
          Container(
            decoration: BoxDecoration(
              color: AppColors.blueLink.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              spacing: 10,
              children: [
                const UImage(AppIcons.info, color: AppColors.blue, size: 25),
                Text(s.workshiftCalendarInfo).bodyMedium(color: AppColors.blue).expanded(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _dayKey(final Jalali date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  List<Widget> _buildChips(final BuildContext context, final Set<String> slugs) {
    if (slugs.isEmpty) return const [];
    // Filter out night shifts - they are displayed as NightShiftSpan instead
    final list = slugs
        .map((final s) => shiftTypeRegistry[s])
        .whereType<ShiftTypeReadDto>()
        .where((final st) => !_isNightShift(st))
        .toList();

    if (list.isEmpty) return const [];

    // Show up to 2, then +N
    final visible = list.take(2).toList();
    final extra = list.length - visible.length;

    final widgets = <Widget>[
      for (final st in visible)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: (st.color.color).withAlpha(35),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: (st.color.color).withAlpha(70)),
          ),
          // child: Text(
          //   st.title,
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          // ).bodySmall(),
        ),
      if (extra > 0)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: context.theme.dividerColor.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          // child: Text('+$extra').bodySmall(),
        ),
    ];
    return widgets;
  }

  /// Checks if a shift type is a night shift (starts after end time, crosses midnight).
  bool _isNightShift(final ShiftTypeReadDto st) {
    final start = _parseHm(st.startTime);
    final end = _parseHm(st.endTime);
    if (start == null || end == null) return false;
    return start > end;
  }

  List<NightShiftSpan> _buildNightShiftSpans({
    required final Jalali day,
    required final Set<String> todaySlugs,
    required final Set<String> yesterdaySlugs,
  }) {
    final spans = <NightShiftSpan>[];

    // Start segment (shift starts today, ends next day)
    for (final slug in todaySlugs) {
      final st = shiftTypeRegistry[slug];
      if (st == null) continue;
      final start = _parseHm(st.startTime);
      final end = _parseHm(st.endTime);
      if (start == null || end == null) continue;
      if (start <= end) continue;
      spans.add(NightShiftSpan(shiftType: st, segment: NightShiftSegment.start));
    }

    // End segment (shift started yesterday and ends today)
    for (final slug in yesterdaySlugs) {
      final st = shiftTypeRegistry[slug];
      if (st == null) continue;
      final start = _parseHm(st.startTime);
      final end = _parseHm(st.endTime);
      if (start == null || end == null) continue;
      if (start <= end) continue;
      spans.add(NightShiftSpan(shiftType: st, segment: NightShiftSegment.end));
    }

    return spans;
  }

  int? _parseHm(final String hm) {
    final parts = hm.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.chips,
    required this.nightShiftSpans,
    required this.onTap,
  });

  final int day;
  final List<Widget> chips;
  final List<NightShiftSpan> nightShiftSpans;
  final VoidCallback onTap;

  static const int chipsLimit = 2;
  static const int maxChips = 9;

  int get shiftsCount => nightShiftSpans.length + chips.length;

  bool get showChips => shiftsCount > 0 && shiftsCount <= chipsLimit;

  bool get showChipsCount => shiftsCount > chipsLimit && shiftsCount <= maxChips;

  bool get showMoreThanChips => shiftsCount > maxChips;

  @override
  Widget build(final BuildContext context) {
    return WCard(
      showBorder: true,
      padding: 6,
      elevation: 0,
      margin: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 2,
        children: [
          Text(day.toString()).bodyMedium().bold(),
          if (showChips)
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (nightShiftSpans.isNotEmpty) ...[
                    ...nightShiftSpans.map((final s) => s.marginOnly(bottom: 2)),
                    if (chips.isNotEmpty) const SizedBox(height: 2),
                  ],
                  if (chips.isNotEmpty)
                    Wrap(
                      spacing: 2,
                      runSpacing: 2,
                      children: chips,
                    ),
                ],
              ),
            )
          else if (showChipsCount || showMoreThanChips)
            Text(
              showChipsCount ? "($shiftsCount)" : '+$maxChips',
            ).bodySmall(color: context.theme.primaryColor).bold(),
        ],
      ),
    );
  }
}
