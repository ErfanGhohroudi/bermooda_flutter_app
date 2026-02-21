import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entities/support_department.dart';

class SupportDepartmentMainSheet extends StatelessWidget {
  const SupportDepartmentMainSheet({
    required this.department,
    super.key,
  });

  final SupportDepartment department;

  @override
  Widget build(final BuildContext context) {
    final haveManagerAccess = Get.find<PermissionService>().haveSupportManagerAccess;
    final haveAdminAccess = Get.find<PermissionService>().haveSupportAdminAccess;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 300),
      child: Column(
        children: [
          /// Board
          _item(
            context: context,
            onTap: () {
              // AppNavigator.push(
              //   ProjectBoardPage(
              //     department: department,
              //     onEdited: onEdited,
              //   ),
              // );
            },
            icon: AppIcons.tickCircleOutline,
            title: s.projectBoard,
          ),

          /// My Tasks
          _item(
            context: context,
            onTap: () {
              // AppNavigator.push(
              //   MyTasksPage(
              //     dataSourceType: SubtaskDataSourceType.department,
              //     projectId: department.id ?? '',
              //   ),
              // );
            },
            icon: AppIcons.listOutline,
            title: s.myTasks,
          ),

          /// Stats
          if (haveManagerAccess)
            _item(
              context: context,
              onTap: () {
                // AppNavigator.push(
                //   ProjectStatisticsPage(
                //     department: department,
                //   ),
                // );
              },
              icon: AppIcons.statisticsOutline,
              title: s.statistics,
            ),

          /// Archive
          if (haveAdminAccess)
            _item(
              context: context,
              onTap: () {
                // AppNavigator.push(
                //   ProjectTasksArchivePage(
                //     projectId: department.id ?? '',
                //   ),
                // );
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
  }) => WCard(
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
