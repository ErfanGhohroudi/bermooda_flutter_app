import 'package:u/utilities.dart';

import '../../../../../core/utils/extensions/date_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import 'timesheet_controller.dart';

class TimesheetPage extends StatefulWidget {
  const TimesheetPage({super.key});

  @override
  State<TimesheetPage> createState() => _TimesheetPageState();
}

class _TimesheetPageState extends State<TimesheetPage> with TimesheetController {
  @override
  void initState() {
    getTimesheet();
    super.initState();
  }

  @override
  void dispose() {
    disposeItem();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      body: WSmartRefresher(
        controller: refreshController,
        enablePullUp: false,
        onRefresh: getTimesheet,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              _monthSelector(),
              Obx(
                () => pageState.isLoaded() ? _timesheetGridView() : _timesheetGridView().shimmer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _monthSelector() => Obx(
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
              // Button to decrease the month
              Container(
                width: 30,
                height: 30,
                color: Colors.transparent,
                child: Icon(Icons.arrow_back_ios_rounded, size: 20, color: decreaseMonthIsEnable ? Colors.white : Colors.grey.shade400),
              ).onTap(decreaseMonth).withTooltip(s.previousMonth),

              // Displays the current month
              Text("${dateSelected.value.formatter.mN.getJalaliMonthNameFaEn()} ${dateSelected.value.formatter.yyyy}").bodyLarge(color: Colors.white),

              // Button to increase the month
              Container(
                width: 30,
                height: 30,
                color: Colors.transparent,
                child: Icon(Icons.arrow_forward_ios_rounded, size: 20, color: increaseMonthIsEnable ? Colors.white : Colors.grey.shade400),
              ).onTap(increaseMonth).withTooltip(s.nextMonth),
            ],
          ),
        ),
      );

  Widget _timesheetGridView() {
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 3.2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      children: [
        _itemBoxWidget(
          title: s.presence,
          icon: AppIcons.presenceOutline,
          iconColor: AppColors.green,
          body: s.total,
          bodyValue: formatSecondsToHoursMinutes(timesheet.totalAttendanceSecond),
          description: s.remaining,
          descriptionValue: formatSecondsToHoursMinutes(timesheet.remainingAttendanceSecond),
        ),
        _itemBoxWidget(
          title: s.absence,
          icon: AppIcons.absenceOutline,
          iconColor: AppColors.red,
          body: s.total,
          bodyValue: formatSecondsToHoursMinutes(timesheet.totalAbsenceSecond),
        ),
        _itemBoxWidget(
          title: s.leave,
          icon: AppIcons.leaveOutline,
          iconColor: Colors.orange,
          body: s.total,
          bodyValue: formatSecondsToHoursMinutes(timesheet.totalLeaveSecond),
          description: s.remaining,
          descriptionValue: formatSecondsToHoursMinutes(timesheet.remainingLeaveSecond),
        ),
        _itemBoxWidget(
          title: s.tardiness,
          icon: AppIcons.dangerOutline,
          iconColor: AppColors.brown,
          body: s.total,
          bodyValue: formatSecondsToHoursMinutes(timesheet.totalTardinessSecond),
        ),
        _itemBoxWidget(
          title: s.overtime,
          icon: AppIcons.briefcaseOutline,
          iconColor: AppColors.blueLink,
          body: s.total,
          bodyValue: formatSecondsToHoursMinutes(timesheet.totalOvertimeSecond),
        ),
        _itemBoxWidget(
          title: s.mission,
          icon: AppIcons.missionOutline,
          iconColor: AppColors.purple,
          body: s.total,
          bodyValue: formatSecondsToHoursMinutes(timesheet.totalMissionSecond),
        ),
      ],
    );
  }

  Widget _itemBoxWidget({
    required final String title,
    required final String icon,
    final Color? iconColor,
    final String? body,
    final String? bodyValue,
    final String? description,
    final String? descriptionValue,
  }) =>
      WCard(
        showBorder: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                WCard(
                  padding: 6,
                  margin: EdgeInsets.zero,
                  color: (iconColor ?? context.theme.primaryColor).withAlpha(50),
                  child: UImage(icon, size: 25, color: iconColor ?? context.theme.primaryColor),
                ),
                Flexible(child: Text(title, maxLines: 1).bodyMedium(color: context.theme.primaryColorDark.withAlpha(160), overflow: TextOverflow.ellipsis).bold()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                Text(body ?? '', maxLines: 1).bodyMedium(overflow: TextOverflow.ellipsis),
                Flexible(child: Text(bodyValue ?? '', maxLines: 1).bodyMedium(overflow: TextOverflow.ellipsis).bold()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                Text(description ?? '', maxLines: 1).bodyMedium(overflow: TextOverflow.ellipsis),
                Flexible(child: Text(descriptionValue ?? '', maxLines: 1).bodyMedium(overflow: TextOverflow.ellipsis).bold()),
              ],
            ),
          ],
        ),
      );
}
