import 'package:bermooda_business/core/utils/extensions/time_extensions.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/theme.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../../data/data.dart';
import '../day_attendance_details/day_attendance_details_bottom_sheet.dart';
import '../helpers/determine_day_status.dart';
import 'member_monthly_attendance_stats_controller.dart';

class MemberMonthlyAttendanceStatsPage extends StatefulWidget {
  const MemberMonthlyAttendanceStatsPage({
    required this.memberId,
    super.key,
  });

  final int? memberId;

  @override
  State<MemberMonthlyAttendanceStatsPage> createState() => _MemberMonthlyAttendanceStatsPageState();
}

class _MemberMonthlyAttendanceStatsPageState extends State<MemberMonthlyAttendanceStatsPage> with MemberMonthlyAttendanceStatsController {
  @override
  int? get memberId => widget.memberId;

  @override
  void initState() {
    initialController();
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      body: WSmartRefresher(
        controller: refreshController,
        onRefresh: onRefresh,
        enablePullUp: false,
        child: Obx(
          () {
            if (pageState.isInitial() || pageState.isLoading()) {
              return _buildShimmerLoading();
            }

            if (pageState.isError()) {
              return Center(
                child: WErrorWidget(onTapButton: onRefreshWithLoading),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                spacing: 16,
                children: [
                  if (member.value?.workPerformanceSummary != null)
                    _buildOverall(),
                  _monthSelector(),
                  _buildMonthCalendar(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverall() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _buildOverallCard(
              title: s.totalWorkHours,
              value: member.value!.workPerformanceSummary!.totalHours.formatHoursToHHMM,
              color: AppColors.blue
            ).expanded(),
            _buildOverallCard(
              title: s.hoursWorked,
              value: member.value!.workPerformanceSummary!.workedHours.formatHoursToHHMM,
              color: AppColors.green
            ).expanded(),
          ],
        ),
        Row(
          children: [
            _buildOverallCard(
                title: s.overtime,
                value: member.value!.workPerformanceSummary!.overtimeHours.formatHoursToHHMM,
                color: AppColors.orange
            ).expanded(),
            _buildOverallCard(
                title: s.attendanceRate,
                value: "${member.value!.workPerformanceSummary!.attendanceRate}%",
                color: AppColors.purple
            ).expanded(),
          ],
        ),
      ],
    );
  }

  Widget _buildOverallCard({
    required final String title,
    required final String value,
    required final Color color,
}) {
    return WCard(
      color: color.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title).titleMedium(color: color),
          Text(value).bodyLarge(color: color).bold(),
        ],
      ),
    );
  }

  Widget _monthSelector() {
    return Obx(
      () => Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: context.theme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 30,
              height: 30,
              color: Colors.transparent,
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 20,
                color: Colors.white,
              ),
            ).onTap(decreaseMonth).withTooltip(s.previousMonth),
            Text(
              "${dateSelected.value.formatter.mN.getJalaliMonthNameFaEn()} ${dateSelected.value.formatter.yyyy}",
            ).bodyLarge(color: Colors.white),
            Container(
              width: 30,
              height: 30,
              color: Colors.transparent,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: increaseMonthIsEnable ? Colors.white : Colors.grey.shade400,
              ),
            ).onTap(increaseMonth).withTooltip(s.nextMonth),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    AttendanceStatus;
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          _buildLegendItem(AttendanceStatus.present),
          _buildLegendItem(AttendanceStatus.absent),
          _buildLegendItem(AttendanceStatus.leave),
          _buildLegendItem(AttendanceStatus.mission),
        ],
      ),
    );
  }

  Widget _buildLegendItem(final AttendanceStatus status) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Stack(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: status.color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        Text(status.title).bodySmall(color: context.theme.hintColor),
      ],
    );
  }

  Widget _buildMonthCalendar() {
    return Obx(
      () {
        if (member.value == null) {
          return const Center(child: WEmptyWidget());
        }

        final monthLength = dateSelected.value.monthLength;
        final firstDayOfMonth = dateSelected.value.withDay(1);
        final firstWeekDay = firstDayOfMonth.weekDay - 1; // 0=Saturday, 6=Friday

        final attendanceData = member.value!.attendanceData ?? [];
        final attendanceMap = <int, DayAttendanceDataDto>{};

        // Create a map of day -> DayAttendanceDataDto
        // jalaliDate format is yyyy/mm/dd, we extract the day number
        for (final dayData in attendanceData) {
          if (dayData.jalaliDate != null) {
            final jalaliParts = dayData.jalaliDate!.split('/');
            if (jalaliParts.length == 3) {
              final year = int.tryParse(jalaliParts[0]);
              final month = int.tryParse(jalaliParts[1]);
              final day = int.tryParse(jalaliParts[2]);

              // Only include days from the current month
              if (year != null && month != null && day != null && year == dateSelected.value.year && month == dateSelected.value.month) {
                attendanceMap[day] = dayData;
              }
            }
          }
        }

        final List<String> persianWeekDays = ["ش", "ی", "د", "س", "چ", "پ", "ج"];
        final List<String> englishWeekDays = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];

        final weekDayNames = isPersianLang ? persianWeekDays : englishWeekDays;

        return Container(
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.theme.dividerColor,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Week day names header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor.withAlpha(20),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: [
                    _buildLegend(),
                    Row(
                      children: weekDayNames
                          .map(
                            (final dayName) => Expanded(
                              child: Center(
                                child: Text(dayName).bodyMedium(
                                  fontWeight: FontWeight.bold,
                                  color: context.theme.primaryColor,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              // Calendar days grid
              Padding(
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 1,
                  ),
                  itemCount: monthLength + firstWeekDay,
                  itemBuilder: (final context, final index) {
                    // Display empty placeholders for days before the start of the month
                    if (index < firstWeekDay) {
                      return const SizedBox();
                    }

                    final int day = index - firstWeekDay + 1;
                    final dayDate = dateSelected.value.withDay(day);
                    return _buildDayCell(dayDate, attendanceMap);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayCell(final Jalali date, final Map<int, DayAttendanceDataDto> attendanceMap) {
    final DayAttendanceDataDto? dayData = attendanceMap[date.day];
    AttendanceStatus status = determineDayStatus(dayData);

    final todayNumeric = Jalali.now().formatCompactDate().numericOnly().toInt();
    final dayNumeric = date.formatCompactDate().numericOnly().toInt();
    final isToday = dayNumeric == todayNumeric;
    final isAfterToday = dayNumeric > todayNumeric;

    if (isAfterToday && (status == AttendanceStatus.present || status == AttendanceStatus.absent)) {
      status = AttendanceStatus.empty;
    }

    return GestureDetector(
      onTap: () => showDayAttendanceDetails(date, dayData),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        decoration: BoxDecoration(
          color: status.color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isToday ? context.theme.primaryColor : context.theme.dividerColor,
            width: isToday ? 2 : 0.5,
          ),
        ),
        child: Center(
          child: Text('${date.day}').titleMedium(),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        spacing: 16,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    ).shimmer();
  }
}
