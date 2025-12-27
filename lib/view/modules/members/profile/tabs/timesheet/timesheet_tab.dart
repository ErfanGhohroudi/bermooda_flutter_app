import 'package:u/utilities.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../human_resource/attendance/statistics/member_monthly_stats/member_monthly_attendance_stats_page.dart';
import '../../profile_controller.dart';

class TimesheetTab extends StatelessWidget {
  const TimesheetTab({
    required this.controller,
    super.key,
  });

  final ProfileController controller;

  @override
  Widget build(final BuildContext context) {
    if (controller.hrModuleIsActive == false) {
      return Center(
        child: WErrorWidget(
          iconString: AppIcons.info,
          iconColor: context.theme.hintColor,
          errorTitle: s.hRModuleIsRequired,
          size: 50,
          onTapButton: () {},
        ),
      );
    }

    return MemberMonthlyAttendanceStatsPage(memberId: controller.memberId);
  }
}
