import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';
import 'day_attendance_details/day_attendance_details_bottom_sheet.dart';
import 'helpers/determine_day_status.dart';
import 'monthly_attendance_stats_controller.dart';

class MonthlyAttendanceStatsPage extends StatefulWidget {
  const MonthlyAttendanceStatsPage({
    required this.department,
    super.key,
  });

  final HRDepartmentReadDto department;

  @override
  State<MonthlyAttendanceStatsPage> createState() => _MonthlyAttendanceStatsPageState();
}

class _MonthlyAttendanceStatsPageState extends State<MonthlyAttendanceStatsPage> with MonthlyAttendanceStatsController {
  @override
  String get departmentSlug => widget.department.slug ?? '';

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
      appBar: AppBar(title: Text(s.attendance)),
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
                  if (statisticsSummary.value != null) _buildStatisticsCards(),
                  _monthSelector(),
                  _buildAttendanceTable(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return Obx(
      () {
        final stats = statisticsSummary.value;
        if (stats == null) return const SizedBox.shrink();

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: s.mission,
                    value: stats.missionsCount ?? 0,
                    percentage: stats.missionsPercentage ?? 0,
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    title: s.absence,
                    value: stats.absentCount ?? 0,
                    percentage: stats.absentPercentage ?? 0,
                    color: AppColors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: s.presence,
                    value: stats.presentCount ?? 0,
                    percentage: stats.presentPercentage ?? 0,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    title: s.members,
                    value: stats.totalMembersCount ?? 0,
                    percentage: stats.totalMembersPercentage ?? 0,
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required final String title,
    required final int value,
    required final double percentage,
    required final Color color,
  }) {
    return WCard(
      color: color.withAlpha(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: CircularPercentIndicator(
              radius: 30,
              lineWidth: 4,
              percent: (percentage / 100).clamp(0.0, 1.0),
              center: Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              progressColor: color,
              backgroundColor: color.withAlpha(50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: context.theme.hintColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
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

  Widget _buildAttendanceTable() {
    if (members.isEmpty) {
      return const Center(child: WEmptyWidget());
    }

    final monthLength = dateSelected.value.monthLength;

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
          _buildTableHeader(monthLength),
          SizedBox(
            height: 400,
            child: ListView.separated(
              itemCount: members.length,
              separatorBuilder: (final context, final index) => const Divider(height: 1),
              itemBuilder: (final context, final index) => _buildEmployeeRow(members[index], monthLength, index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(final int monthLength) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: context.theme.primaryColor.withAlpha(20),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        spacing: 8,
        children: [
          _buildLegend(),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Center(
                  child: Text(s.fullName).bodyMedium(
                    fontWeight: FontWeight.bold,
                    color: context.theme.primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: horizontalScrollController,
                  child: Row(
                    children: List.generate(
                      monthLength,
                      (final index) {
                        final day = index + 1;
                        final isToday =
                            dateSelected.value.withDay(day).formatCompactDate().numericOnly().toInt() == Jalali.now().formatCompactDate().numericOnly().toInt();

                        return Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: isToday
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: context.theme.primaryColor,
                                )
                              : null,
                          child: Center(
                            child: Text('$day').bodySmall(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isToday ? Colors.white : context.theme.primaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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

  Widget _buildEmployeeRow(
    final MemberAttendanceSummaryReadDto member,
    final int monthLength,
    final int rowIndex,
  ) {
    final attendanceData = member.attendanceData ?? [];
    final attendanceMap = <int, DayAttendanceDataDto>{};
    for (final dayData in attendanceData) {
      if (dayData.jalaliDate != null) {
        final jalaliParts = dayData.jalaliDate!.split('/');
        if (jalaliParts.length == 3) {
          final day = int.tryParse(jalaliParts[2]);
          if (day != null) {
            attendanceMap[day] = dayData;
          }
        }
      }
    }

    // ایجاد یا استفاده از ScrollController موجود برای این ردیف
    ScrollController rowScrollController;
    if (rowIndex < employeeRowScrollControllers.length) {
      rowScrollController = employeeRowScrollControllers[rowIndex];
    } else {
      rowScrollController = createEmployeeRowScrollController();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: WCircleAvatar(
              size: 30,
              user: UserReadDto(
                id: member.id?.toString() ?? '',
                avatar: member.avatar,
                fullName: member.fullname ?? '- -',
              ),
              showFullName: true,
              maxLines: 2,
              bodySmall: true,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: rowScrollController,
              child: Row(
                children: List.generate(
                  monthLength,
                  (final index) {
                    final date = dateSelected.value.withDay(index + 1);
                    final DayAttendanceDataDto? dayData = attendanceMap[date.day];
                    AttendanceStatus status = determineDayStatus(dayData);

                    final todayNumeric = Jalali.now().formatCompactDate().numericOnly().toInt();
                    final dayNumeric = date.formatCompactDate().numericOnly().toInt();
                    final isAfterToday = dayNumeric > todayNumeric;

                    if (isAfterToday && (status == AttendanceStatus.present || status == AttendanceStatus.absent)) {
                      status = AttendanceStatus.empty;
                    }

                    return GestureDetector(
                      onTap: () => showDayAttendanceDetails(date, dayData),
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: status.color,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: context.theme.dividerColor,
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: status != AttendanceStatus.empty
                              ? UImage(
                                  status.icon,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        spacing: 16,
        children: [
          Row(
            children: List.generate(
              4,
              (final index) => Expanded(
                child: Container(
                  height: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
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
            height: 400,
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
