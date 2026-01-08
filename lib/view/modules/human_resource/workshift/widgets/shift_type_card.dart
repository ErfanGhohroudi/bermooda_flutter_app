import 'package:u/utilities.dart';

import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../data/data.dart';
import '../detail/widgets/night_shift_span.dart';
import '../detail/workshift_detail_controller.dart';

class WShiftTypeCard extends StatelessWidget {
  const WShiftTypeCard({
    required this.shiftType,
    required this.controller,
    required this.day,
    required this.dayKey,
    this.nightShiftSegment,
    super.key,
  });

  final ShiftTypeReadDto shiftType;
  final WorkshiftDetailController controller;
  final Jalali day;
  final String dayKey;

  /// null = day shift, start/end for night shifts
  final NightShiftSegment? nightShiftSegment;

  bool get _isNightShift => nightShiftSegment != null;

  BoxBorder _border(final Color borderColor) {
    if (!_isNightShift) {
      return Border.all(color: borderColor, width: 2);
    }

    final defaultBorderSide = BorderSide(color: borderColor, width: 2);

    final nightShiftBorderSide = BorderSide(color: borderColor, width: 8);

    final startNightShiftBorder = BorderDirectional(
      top: defaultBorderSide,
      bottom: defaultBorderSide,
      start: defaultBorderSide,
      end: nightShiftBorderSide,
    );

    final endNightShiftBorder = BorderDirectional(
      top: defaultBorderSide,
      bottom: defaultBorderSide,
      start: nightShiftBorderSide,
      end: defaultBorderSide,
    );

    return switch (nightShiftSegment!) {
      NightShiftSegment.start => startNightShiftBorder,
      NightShiftSegment.end => endNightShiftBorder,
    };
  }

  BorderRadiusGeometry get _borderRadius {
    if (!_isNightShift) return BorderRadius.circular(12);

    // For night shifts, flatten one side to show continuation
    // segment == start: end border radius = 0 (shift continues to next day)
    // segment == end: start border radius = 0 (shift started from previous day)
    return switch (nightShiftSegment!) {
      NightShiftSegment.start => const BorderRadiusDirectional.horizontal(start: Radius.circular(15)),
      NightShiftSegment.end => const BorderRadiusDirectional.horizontal(end: Radius.circular(15)),
    };
  }

  /// For night shift end segment, we need to use the actual start day (previous day)
  Jalali get _actualShiftDay => nightShiftSegment == NightShiftSegment.end ? day.addDays(-1) : day;

  String get _actualDayKey =>
      nightShiftSegment == NightShiftSegment.end ? controller.getDayKeyFromJalali(_actualShiftDay) : dayKey;

  void _onDeleteFromDay() {
    final targetDay = _actualShiftDay;
    final targetDayKey = _actualDayKey;

    if (controller.isShiftTypeInDraftOnly(shiftType.slug, targetDayKey)) {
      controller.removeShiftTypeFromDraftLocal(
        shiftType.slug,
        targetDay,
        targetDay,
        isAllDays: false,
      );
    } else {
      controller.deleteShiftTypeFromDays(
        shiftType,
        startDate: targetDay,
        endDate: targetDay,
        isAllDays: false,
      );
    }
  }

  void _onDeleteFromAllDays() {
    final range = controller.getShiftTypeDateRange(shiftType.slug);
    if (range == null) return;
    final (startDate, endDate) = range;

    if (controller.areAllDaysInDraftOnly(shiftType.slug, startDate, endDate)) {
      controller.removeShiftTypeFromDraftLocal(
        shiftType.slug,
        startDate,
        endDate,
        isAllDays: true,
      );
    } else {
      controller.deleteShiftTypeFromDays(
        shiftType,
        startDate: startDate,
        endDate: endDate,
        isAllDays: true,
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    final cardColor = shiftType.color?.color ?? context.theme.cardColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.05),
        borderRadius: _borderRadius,
        border: _border(cardColor.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsetsDirectional.only(top: 12, bottom: 12, start: 12, end: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            children: [
              if (_isNightShift) ...[
                UImage(AppIcons.moon, size: 20, color: cardColor),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  shiftType.shiftRangeTime,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ).titleMedium().bold(),
              ),
              if (controller.haveAdminAccess)
                WMoreButtonIcon(
                  items: [
                    WPopupMenuItem(
                      title: s.deleteFromDay,
                      icon: AppIcons.delete,
                      iconColor: AppColors.red,
                      titleColor: AppColors.red,
                      onTap: _onDeleteFromDay,
                    ),
                    WPopupMenuItem(
                      title: s.deleteFromAllDay,
                      icon: AppIcons.delete,
                      iconColor: AppColors.red,
                      titleColor: AppColors.red,
                      onTap: _onDeleteFromAllDays,
                    ),
                  ],
                ),
            ],
          ),
          if (shiftType.breakStartTime != null && shiftType.breakEndTime != null)
            Text(
              '${s.breakText}: ${shiftType.breakStartTime} - ${shiftType.breakEndTime}',
            ).bodySmall(color: context.theme.hintColor),
          if (shiftType.flexibleStartTime != null || shiftType.flexibleEndTime != null)
            Text(
              '${s.floatingTime}: '
              "${shiftType.flexibleStartTime != null ? '${s.entry} ${shiftType.flexibleStartTime}' : ''}"
              "${shiftType.flexibleStartTime != null && shiftType.flexibleEndTime != null ? ' - ' : ''}"
              "${shiftType.flexibleEndTime != null ? '${s.exit} ${shiftType.flexibleEndTime}' : ''}",
            ).bodySmall(color: context.theme.hintColor),
        ],
      ),
    );
  }
}
