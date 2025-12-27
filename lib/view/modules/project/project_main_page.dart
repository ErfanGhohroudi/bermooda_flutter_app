import 'package:u/utilities.dart';

import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/theme.dart';
import '../../../data/data.dart';

// import '../../../kanban_board_with_subtasks_and_cache (2).dart';
import 'archive/project_archive_page.dart';
import 'board/project_board_page.dart';
import 'my_tasks/my_tasks_page.dart';
import 'statistics/project_statistics_page.dart';

class ProjectMainPage extends StatelessWidget {
  const ProjectMainPage({
    required this.project,
    required this.onEdited,
    super.key,
  });

  final ProjectReadDto project;
  final Function(ProjectReadDto project) onEdited;

  @override
  Widget build(final BuildContext context) {
    final haveManagerAccess = Get.find<PermissionService>().haveProjectManagerAccess;
    final haveAdminAccess = Get.find<PermissionService>().haveProjectAdminAccess;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 300),
      child: Column(
        children: [
          /// Board
          _item(
            context: context,
            onTap: () => UNavigator.push(
              ProjectBoardPage(
                project: project,
                onEdited: onEdited,
              ),
            ),
            // onTap: () => UNavigator.push(KanbanPage()),
            icon: AppIcons.tickCircleOutline,
            title: s.projectBoard,
          ),
          /// My Tasks
          _item(
            context: context,
            onTap: () => UNavigator.push(
              MyTasksPage(
                dataSourceType: SubtaskDataSourceType.project,
                projectId: project.id ?? '',
              ),
            ),
            icon: AppIcons.listOutline,
            title: s.myTasks,
          ),
          /// Stats
          if (haveManagerAccess)
            _item(
              context: context,
              onTap: () => UNavigator.push(
                ProjectStatisticsPage(
                  project: project,
                ),
              ),
              icon: AppIcons.statisticsOutline,
              title: s.statistics,
            ),
          /// Archive
          if (haveAdminAccess)
            _item(
              context: context,
              onTap: () {
                UNavigator.push(
                  ProjectArchivePage(
                    projectId: project.id ?? '',
                  ),
                );
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
      UNavigator.back();
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
