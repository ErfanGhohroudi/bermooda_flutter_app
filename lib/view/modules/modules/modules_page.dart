import 'package:u/utilities.dart';

import '../../../app_config.dart';
import '../../../core/navigator/navigator.dart';
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
import '../sms/presentation/pages/department_list_page.dart';
import '../support/presentation/pages/department_list_page.dart';
import '../voip/presentation/pages/department_list_page.dart';
import '../warehouse/presentation/pages/warehouse_list_page.dart';
import 'modules_controller.dart';
import 'widgets/module_card/module_card.dart';
import 'widgets/module_grid/expandable_modules_grid.dart';

class ModulesPage extends StatefulWidget {
  const ModulesPage({
    this.isBottomSheet = false,
    super.key,
  });

  final bool isBottomSheet;

  @override
  State<ModulesPage> createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> with ModulesController {
  bool get isBottomSheet => widget.isBottomSheet;

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

    return isBottomSheet
        ? (modules.isEmpty
              ? SizedBox(
                  height: context.height * 0.4,
                  child: Center(
                    child: Text(s.notActiveModules).titleMedium(),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isWorkspaceOwner && (subIsNoPurchased || subIsExpired || subWillExpiringSoon)) ...[
                      _subscriptionStatus(),
                      const SizedBox(height: 12),
                    ],
                    WExpandableCardGrid(modules: modules).marginOnly(bottom: 8, top: 12),
                  ],
                ).marginOnly(bottom: 24))
        : UScaffold(
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
                            _subscriptionStatus().pSymmetric(horizontal: 16),
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
    if (perService.isWorkspaceOwner || AppConfig.instance.isDevelopment)
      WModuleCard(
        title: s.staffManagement,
        icon: AppIcons.staffManagementModule,
        isBottomSheet: isBottomSheet,
        onTap: () => AppNavigator.push(const MembersManagementPage()),
      ),
    if ((subService.projectModuleIsActive && perService.haveProjectAccess) || AppConfig.instance.isDevelopment)
      WModuleCard(
        title: s.project,
        icon: AppIcons.projectModule,
        isBottomSheet: isBottomSheet,
        onTap: () => AppNavigator.push(const ProjectListPage()),
      ),
    if ((subService.crmModuleIsActive && perService.haveCRMAccess) || AppConfig.instance.isDevelopment)
      WModuleCard(
        title: s.customers,
        icon: AppIcons.crmModule,
        isBottomSheet: isBottomSheet,
        onTap: () => AppNavigator.push(const CrmCategoriesListPage()),
      ),
    if (subService.hrModuleIsActive || AppConfig.instance.isDevelopment) ...[
      if (perService.haveHRAccess || AppConfig.instance.isDevelopment)
        WModuleCard(
          title: s.humanResources,
          icon: AppIcons.humanResourceModule,
          isBottomSheet: isBottomSheet,
          onTap: () => AppNavigator.push(const HrDepartmentsListPage()),
        ),
      if (subService.requestsModuleIsActive || AppConfig.instance.isDevelopment)
        WModuleCard(
          title: s.requests,
          icon: AppIcons.requestModule,
          isBottomSheet: isBottomSheet,
          onTap: () => AppNavigator.push(const RequestMainPage()),
        ),
    ],
    if (AppConfig.instance.isDevelopment)
      // if (subService.legalModuleIsActive && perService.haveLegalAccess)
      WModuleCard(
        title: s.legal,
        icon: AppIcons.legalModule,
        isBottomSheet: isBottomSheet,
        onTap: () => AppNavigator.push(const LegalDepartmentListPage()),
      ),
    if (AppConfig.instance.isDevelopment)
      // if (subService.lettersModuleIsActive && perService.haveLettersAccess)
      WModuleCard(
        title: s.correspondence,
        icon: AppIcons.mailColor,
        isBottomSheet: isBottomSheet,
        onTap: () => AppNavigator.push(const LettersListPage()),
      ),
    if (subService.employmentModuleIsActive && false)
      WModuleCard(
        title: s.employment,
        icon: AppIcons.employmentModule,
        isBottomSheet: isBottomSheet,
        onTap: () {},
      ),
    if (AppConfig.instance.isDevelopment)
      // if (subService.warehouseModuleIsActive && perService.haveWarehouseAccess)
      WModuleCard(
        title: s.warehouseModuleName,
        icon: AppIcons.warehouseModule,
        isBottomSheet: isBottomSheet,
        onTap: () => AppNavigator.push(const WarehouseListPage()),
      ),
    if (AppConfig.instance.isDevelopment)
      // if (subService.smsModuleIsActive && perService.haveSMSAccess)
      WModuleCard(
        title: s.sms,
        icon: AppIcons.smsModule,
        isBottomSheet: isBottomSheet,
        onTap: () => AppNavigator.push(const SmsDepartmentListPage()),
      ),
    if (AppConfig.instance.isDevelopment)
      // if (subService.cloudCallModuleIsActive && perService.haveCloudCallAccess)
      WModuleCard(
        title: s.cloudCall,
        icon: AppIcons.callOutline,
        isBottomSheet: isBottomSheet,
        onTap: () => AppNavigator.push(const VoipDepartmentListPage()),
      ),
    if (AppConfig.instance.isDevelopment)
      // if (subService.supportModuleIsActive && perService.haveSupportAccess)
      WModuleCard(
        title: s.support,
        icon: AppIcons.supportModule,
        isBottomSheet: isBottomSheet,
        onTap: () => AppNavigator.push(const SupportDepartmentListPage()),
      ),
    if (AppConfig.instance.isDevelopment)
      // if (subService.marketingModuleIsActive && perService.haveMarketingAccess)
      WModuleCard(
        title: s.marketing,
        icon: AppIcons.marketingModule,
        isBottomSheet: isBottomSheet,
        onTap: () {},
      ),
    if (false)
      WModuleCard(
        title: 'اسناد من',
        icon: AppIcons.myDocsModule,
        isBottomSheet: isBottomSheet,
        onTap: () {},
      ),
    if (false)
      WModuleCard(
        title: s.support,
        icon: AppIcons.supportModule,
        isBottomSheet: isBottomSheet,
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
    );
  }
}
