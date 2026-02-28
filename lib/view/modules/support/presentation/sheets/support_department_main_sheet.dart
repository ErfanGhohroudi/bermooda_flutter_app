import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/entities/support_department.dart';
import '../bindings/my_chats_list_binding.dart';
import '../pages/my_chats_list_page.dart';
import '../pages/support_board_page.dart';
import '../bindings/support_board_binding.dart';

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
              AppNavigator.push(
                const SupportBoardPage(),
                binding: SupportBoardBinding(department: department),
              );
            },
            icon: AppIcons.tickCircleOutline,
            title: "s.conversationsBoard",
          ),

          /// My Replies
          _item(
            context: context,
            onTap: () {
              AppNavigator.push(
                const SupportMyChatsListPage(),
                binding: SupportMyChatsListBinding(departmentId: department.id),
              );
            },
            icon: AppIcons.chatOutline,
            title: "s.myReplies",
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
