part of 'base_item_cards.dart';

class HistoryFollowupArchiveCard extends StatelessWidget {
  const HistoryFollowupArchiveCard({
    required this.model,
    required this.showStartMargin,
    required this.canEdit,
    super.key,
  });

  final ReportFollowupArchiveReadDto model;
  final bool showStartMargin;
  final bool canEdit;

  IFollowUpDatasource? get _datasource {
    switch (model.followup?.dataSourceType) {
      case FollowUpDataSource.crm:
        return Get.find<CustomerFollowUpDatasource>();
      case FollowUpDataSource.legal:
        return Get.find<LegalFollowUpDatasource>();
      default:
        return null;
    }
  }

  void restore() {
    if (canEdit == false) return;
    appShowYesCancelDialog(
      title: s.restore,
      description: s.restoreDescription,
      onYesButtonTap: () {
        UNavigator.back();
        _restore();
      },
    );
  }

  void _restore() {
    if (model.followup?.slug == null) return;
    final datasource = _datasource;
    if (datasource == null) return;
    datasource.restore(
      slug: model.followup!.slug,
      onResponse: () {
        _reloadHistory();
        _reloadDetails();
      },
      onError: (final errorResponse) {},
    );
  }

  /// Refresh Reports Page
  void _reloadHistory() {
    if (Get.isRegistered<CrmCustomerReportsController>()) {
      Get.find<CrmCustomerReportsController>().onInit();
    }
    if (Get.isRegistered<LegalCaseReportsController>()) {
      Get.find<LegalCaseReportsController>().onInit();
    }
  }

  /// Refresh Details Page
  void _reloadDetails() {
    if (Get.isRegistered<CustomerInfoController>()) {
      Get.find<CustomerInfoController>().getCustomer();
    }
    if (Get.isRegistered<LegalCaseFollowupListController>()) {
      Get.find<LegalCaseFollowupListController>().onRefresh();
    }
  }

  @override
  Widget build(final BuildContext context) {
    final followup = model.followup;
    final isArchived = model.isArchived;

    final bool haveAdminAccess = Get.find<PermissionService>().haveCRMAdminAccess;

    return baseCard(
      showStartMargin: showStartMargin,
      onTap: followup == null
          ? null
          : () {
              bottomSheetWithNoScroll(
                title: s.details,
                backgroundColor: context.theme.cardColor,
                child: FollowUpDetailsPage(
                  followUp: followup,
                  showSourceData: false,
                  canManage: false,
                  showAppBar: false,
                  onChanged: (final model) {},
                  onDelete: () {},
                ),
              );
            },
      children: [
        baseHeader(context, model, showArrow: true),
        baseBodyText(context, model),
        if (followup != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: [
                  WCircleAvatar(
                    user: followup.assignedUser,
                    size: 30,
                  ),
                  UBadge(
                    badgeContent: Text(followup.files.length.toString()).bodySmall(color: Colors.white),
                    showBadge: followup.files.isNotEmpty,
                    child: UImage(
                      AppIcons.attachment,
                      size: 25,
                      color: followup.files.isNotEmpty ? context.theme.primaryColorDark : context.theme.hintColor,
                    ),
                  ),
                ],
              ),
              if (canEdit && isArchived && haveAdminAccess)
                UElevatedButton(
                  enable: canEdit,
                  title: s.restore,
                  icon: const UImage(AppIcons.restore, size: 15, color: AppColors.red),
                  backgroundColor: context.theme.cardColor,
                  borderColor: AppColors.red,
                  titleColor: AppColors.red,
                  borderWidth: 1,
                  onTap: restore,
                ),
            ],
          ),
      ],
    );
  }
}
