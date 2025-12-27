import 'package:u/utilities.dart';

import '../../../core/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import '../crm/list/crm_categories_list_page.dart';
import '../human_resource/departments/hr_departments_list_page.dart';
import '../legal/departments/legal_department_list_page.dart';
import '../letter/letters/list/letters_list_page.dart';
import '../members/members_management_page.dart';
import '../project/list/project_list_page.dart';
import '../requests/request_main_page.dart';
import 'modules_controller.dart';
import 'widgets/module_card/module_card.dart';
import 'widgets/module_grid/expandable_modules_grid.dart';

class ModulesPage extends StatefulWidget {
  const ModulesPage({super.key});

  @override
  State<ModulesPage> createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> with ModulesController {
  @override
  void initState() {
    // fetchAllData();
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final modules = _getModules();

    return UScaffold(
      body: modules.isEmpty
          ? Center(
              child: Text(s.notActiveModules).titleMedium(),
            )
          : WSmartRefresher(
              enablePullDown: true,
              onRefresh: fetchAllData,
              enablePullUp: false,
              controller: refreshController,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // if (core.bannerUrls.isNotEmpty)
                    //   WBannerSlider(
                    //     imageUrls: core.bannerUrls,
                    //   ),
                    // const SizedBox(height: 26),
                    if (isWorkspaceOwner && (subIsNoPurchased || subIsExpired || subWillExpiringSoon)) ...[
                      _subscriptionStatus(),
                      const SizedBox(height: 12),
                    ],
                    WExpandableCardGrid(modules: modules).paddingSymmetric(horizontal: 16).marginOnly(bottom: 8, top: 12),
                    // Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   spacing: 18,
                    //   children: [
                    //     WNotices(
                    //       notices: notices,
                    //       listState: noticesState,
                    //       onPressedAddButton: () => bottomSheet(
                    //         child: Container(),
                    //       ),
                    //     ),
                    //   ],
                    // ).pSymmetric(horizontal: 16),
                  ],
                ),
              ),
            ),
    );
  }

  List<WModuleCard> _getModules() => [
    if (perService.isWorkspaceOwner || kDebugMode)
      WModuleCard(
        title: s.staffManagement,
        icon: AppIcons.staffManagementModule,
        onTap: () => UNavigator.push(const MembersManagementPage()),
      ),
    if (subService.projectModuleIsActive && perService.haveProjectAccess)
      WModuleCard(
        title: s.project,
        icon: AppIcons.projectModule,
        onTap: () => UNavigator.push(const ProjectListPage()),
      ),
    if (subService.crmModuleIsActive && perService.haveCRMAccess)
      WModuleCard(
        title: s.customers,
        icon: AppIcons.crmModule,
        onTap: () => UNavigator.push(const CrmCategoriesListPage()),
      ),
    if (subService.hrModuleIsActive) ...[
      if (perService.haveHRAccess)
        WModuleCard(
          title: s.humanResources,
          icon: AppIcons.humanResourceModule,
          onTap: () => UNavigator.push(const HrDepartmentsListPage()),
        ),
      if (subService.requestsModuleIsActive)
        WModuleCard(
          title: s.requests,
          icon: AppIcons.requestModule,
          onTap: () => UNavigator.push(const RequestMainPage()),
        ),
    ],
    if ((subService.legalModuleIsActive && perService.haveLegalAccess) || kDebugMode)
      WModuleCard(
        title: s.legal,
        icon: AppIcons.legalModule,
        onTap: () => UNavigator.push(const LegalDepartmentListPage()),
      ),
    if (kDebugMode)
      // if (subService.lettersModuleIsActive && perService.haveLettersAccess)
      WModuleCard(
        title: s.correspondence,
        icon: AppIcons.mailColor,
        onTap: () => UNavigator.push(const LettersListPage()),
      ),
    if (subService.employmentModuleIsActive && false)
      WModuleCard(
        title: s.employment,
        icon: AppIcons.employmentModule,
        onTap: () {},
      ),
    if (false)
      WModuleCard(
        title: 'انبارداری',
        icon: AppIcons.warehouseModule,
        onTap: () {},
      ),
    if (subService.marketingModuleIsActive)
      // if (subService.marketingModuleIsActive && perService.haveMarketingAccess)
      WModuleCard(
        title: s.marketing,
        icon: AppIcons.marketingModule,
        onTap: () {},
      ),
    if (false)
      WModuleCard(
        title: 'اسناد من',
        icon: AppIcons.myDocsModule,
        onTap: () {},
      ),
    if (false)
      WModuleCard(
        title: s.support,
        icon: AppIcons.supportModule,
        onTap: () {},
      ),
  ];

  Widget _subscriptionStatus() {
    final color = subIsNoPurchased || subIsExpired ? AppColors.red : subStatus.color;
    return WCard(
      showBorder: true,
      borderColor: color.withValues(alpha: 0.3),
      color: color.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              UImage(AppIcons.info, color: color, size: 20),
              Text(
                isPersianLang ? "${s.status} ${s.subscription}:" : "${s.subscription} ${s.status}:",
              ).bodyMedium(color: context.theme.hintColor),
            ],
          ),
          Text(subIsNoPurchased ? subIsNoPurchasedText : subStatus.title).bodySmall(color: context.theme.hintColor),
        ],
      ),
    ).pSymmetric(horizontal: 16);
  }
}
