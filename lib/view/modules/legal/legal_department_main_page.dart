import 'package:u/utilities.dart';

import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/theme.dart';
import '../../../data/data.dart';
import 'archive/archived_legal_cases_page.dart';
import 'board/legal_board_page.dart';
import 'my_cases/my_cases_page.dart';
import 'statistics/legal_statistics_page.dart';

class LegalDepartmentMainPage extends StatelessWidget {
  const LegalDepartmentMainPage({
    required this.department,
    required this.onEdited,
    super.key,
  });

  final LegalDepartmentReadDto department;
  final Function(LegalDepartmentReadDto department) onEdited;

  @override
  Widget build(final BuildContext context) {
    final haveManagerAccess = Get.find<PermissionService>().haveLegalManagerAccess;
    final haveAdminAccess = Get.find<PermissionService>().haveLegalAdminAccess;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 300),
      child: Column(
        children: [
          /// Board
          _item(
            context: context,
            onTap: () {
              UNavigator.push(
                LegalBoardPage(
                  department: department,
                  onEdited: onEdited,
                ),
              );
            },
            icon: AppIcons.tickCircleOutline,
            title: s.casesBoard,
          ),
          /// My Cases
          _item(
            context: context,
            onTap: () {
              UNavigator.push(
                MyCasesPage(
                  legalDepartmentId: int.parse(department.id ?? '0'),
                ),
              );
            },
            icon: AppIcons.listOutline,
            title: s.myCase,
          ),
          /// Stats
          if (haveManagerAccess)
            _item(
              context: context,
              onTap: () {
                UNavigator.push(LegalStatisticsPage(legalDepartment: department));
              },
              icon: AppIcons.progressStatusOutline,
              title: s.statistics,
            ),
          /// Archive
          if (haveAdminAccess)
            _item(
              context: context,
              onTap: () {
                UNavigator.push(
                  ArchivedLegalCasesPage(
                    legalDepartmentId: int.parse(department.id ?? '0'),
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
