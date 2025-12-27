import 'package:u/utilities.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import 'dashboard_reports_controller.dart';

part "widgets/dashboard_card.dart";

class DashboardReportsPage extends StatefulWidget {
  const DashboardReportsPage({super.key});

  @override
  State<DashboardReportsPage> createState() => _DashboardReportsPageState();
}

class _DashboardReportsPageState extends State<DashboardReportsPage> with DashboardReportsController {
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
    return Obx(
      () {
        if (pageState.isInitial() || pageState.isLoading()) {
          return const Center(child: WCircularLoading());
        }

        if (pageState.isError()) {
          return Center(child: WErrorWidget(onTapButton: onTryAgain));
        }

        return WSmartRefresher(
          controller: refreshController,
          enablePullUp: false,
          onRefresh: onRefresh,
          child: ListView(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 10),
            children: [
              /// To-Do
              DashboardCard(
                label: s.todo,
                iconString: AppIcons.clockOutline,
                color: AppColors.orange,
                items: [
                  DashboardCardItem(
                    iconData: Icons.menu_rounded,
                    color: AppColors.orange,
                    label: s.subtasks,
                    value: projectSummery.uncompletedSubtasks,
                  ),
                  DashboardCardItem(
                    iconData: Icons.call,
                    color: AppColors.orange,
                    label: s.followUps,
                    value: crmSummery.uncompletedFollowups,
                  ),
                ],
              ),
              /// Done
              DashboardCard(
                label: s.doned,
                iconString: AppIcons.tickCircleOutline,
                color: AppColors.green,
                items: [
                  DashboardCardItem(
                    iconData: Icons.menu_rounded,
                    color: AppColors.green,
                    label: s.subtasks,
                    value: projectSummery.completedSubtasks,
                  ),
                  DashboardCardItem(
                    iconData: Icons.call,
                    color: AppColors.green,
                    label: s.followUps,
                    value: crmSummery.completedFollowups,
                  ),
                ],
              ),
              /// Overdue
              DashboardCard(
                label: s.overdue,
                iconString: AppIcons.warningOutline,
                color: AppColors.red,
                items: [
                  DashboardCardItem(
                    iconData: Icons.menu_rounded,
                    color: AppColors.red,
                    label: s.subtasks,
                    value: projectSummery.completedSubtasks,
                  ),
                  DashboardCardItem(
                    iconData: Icons.call,
                    color: AppColors.red,
                    label: s.followUps,
                    value: crmSummery.completedFollowups,
                  ),
                ],
              ),
              /// User Activity
              DashboardCard(
                label: s.userActivity,
                iconString: AppIcons.groupOutline,
                color: AppColors.blue,
                items: [
                  DashboardCardItem(
                    iconData: Icons.person_add_alt_1_rounded,
                    color: AppColors.green,
                    label: s.online,
                    value: onlineUsersSummery.onlineUsersCount,
                  ),
                  DashboardCardItem(
                    iconData: Icons.person_remove_alt_1_rounded,
                    color: Colors.blueGrey,
                    label: s.offline,
                    value: onlineUsersSummery.allUsersCount - onlineUsersSummery.onlineUsersCount,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
