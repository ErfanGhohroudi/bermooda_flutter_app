import 'package:u/utilities.dart';

import '../../../core/navigator/navigator.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/theme.dart';
import '../../../data/data.dart';
import 'archive/members/hr_archived_members_page.dart';
import 'attendance/statistics/monthly_attendance_stats_page.dart';
import 'board/hr_board_page.dart';
import 'my_reviews/my_reviews_page.dart';
import 'statistics/hr_statistics_page.dart';
import 'workshift/workshift_list_page.dart';

class HrDepartmentMainPage extends StatelessWidget {
  const HrDepartmentMainPage({
    required this.department,
    required this.onEdited,
    super.key,
  });

  final HRDepartmentReadDto department;
  final Function(HRDepartmentReadDto department) onEdited;

  @override
  Widget build(final BuildContext context) {
    final haveManagerAccess = Get.find<PermissionService>().haveHRManagerAccess;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 300),
      child: Column(
        children: [
          _item(
            context: context,
            onTap: () {
              AppNavigator.push(HRBoardPage(
                department: department,
                onEdited: onEdited,
              ));
            },
            icon: AppIcons.tickCircleOutline,
            title: s.requestsBoard,
          ),
          // _item(
          //   context: context,
          //   onTap: () {
          //     AppNavigator.push(MembersListPage(
          //       department: department,
          //     ));
          //   },
          //   icon: AppIcons.listOutline,
          //   title: s.membersList,
          // ),
          _item(
            context: context,
            onTap: () {
              AppNavigator.push(MyReviewsPage(
                department: department,
              ));
            },
            icon: AppIcons.listOutline,
            title: s.myReviews,
          ),
          if (haveManagerAccess)
            _item(
              context: context,
              onTap: () {
                AppNavigator.push(HrStatisticsPage(department: department));
              },
              icon: AppIcons.progressStatusOutline,
              title: s.statistics,
            ),
          if (haveManagerAccess)
            _item(
              context: context,
              onTap: () {
                AppNavigator.push(MonthlyAttendanceStatsPage(department: department));
              },
              icon: AppIcons.timerOutline,
              title: s.attendance,
            ),
          if (haveManagerAccess && department.slug != null)
            _item(
              context: context,
              onTap: () {
                AppNavigator.push(WorkshiftListPage(
                  departmentSlug: department.slug!,
                ));
              },
              icon: AppIcons.workshift,
              title: s.workShift,
            ),
          _item(
            context: context,
            onTap: () {
              AppNavigator.push(HRArchivedMembersPage(
                department: department,
              ));
            },
            icon: AppIcons.archiveOutline,
            title: s.archive,
          ),
        ],
      ),
    );
  }

  Widget _item({
    required final BuildContext context,
    required final String icon,
    required final String title,
    required final VoidCallback onTap,
  }) =>
      WCard(
        onTap: () {
          AppNavigator.back();
          delay(500, onTap);
        },
        child: Row(
          spacing: 12,
          children: [
            UImage(icon, size: 25, color: context.theme.hintColor),
            Expanded(child: Text(title).titleMedium()),
            Icon(Icons.arrow_forward_ios_rounded, color: context.theme.hintColor),
          ],
        ),
      );
}
