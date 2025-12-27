import 'package:u/utilities.dart';

import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/theme.dart';
import '../../../data/data.dart';
import 'archive/crm_archive_page.dart';
import 'board/crm_board_page.dart';
import 'customers_bank/customers_bank_page.dart';
import 'my_followups/my_followups_page.dart';
import 'statisticss/crm_statistics_page.dart';

class CrmCategoryMainPage extends StatelessWidget {
  const CrmCategoryMainPage({
    required this.category,
    required this.onEdited,
    super.key,
  });

  final CrmCategoryReadDto category;
  final Function(CrmCategoryReadDto category) onEdited;

  @override
  Widget build(final BuildContext context) {
    final haveManagerAccess = Get.find<PermissionService>().haveCRMManagerAccess;
    final haveAdminAccess = Get.find<PermissionService>().haveCRMAdminAccess;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 300),
      child: Column(
        children: [
          /// Kanban Board
          _item(
            context: context,
            onTap: () => UNavigator.push(CrmBoardPage(
              category: category,
              onEdited: onEdited,
            )),
            icon: AppIcons.tickCircleOutline,
            title: s.customersBoard,
          ),
          /// My Follow-ups
          _item(
            context: context,
            onTap: () => UNavigator.push(MyFollowupsPage(
              categoryId: category.id ?? '',
            )),
            icon: AppIcons.listOutline,
            title: s.myFollowups,
          ),
          /// Customers Bank
          if (haveAdminAccess)
            _item(
              context: context,
              onTap: () => UNavigator.push(CustomersBankPage(
                categoryId: category.id ?? '',
              )),
              icon: AppIcons.groupOutline,
              title: s.customerDatabase,
            ),
          /// Stats
          if (haveManagerAccess)
            _item(
              context: context,
              onTap: () => UNavigator.push(CrmStatisticsPage(
                category: category,
              )),
              icon: AppIcons.statisticsOutline,
              title: s.statistics,
            ),
          /// Archive
          if (haveAdminAccess)
            _item(
              context: context,
              onTap: () {
                UNavigator.push(CrmArchivePage(
                  categoryId: category.id ?? '',
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
