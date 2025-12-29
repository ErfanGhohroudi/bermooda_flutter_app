part of 'base_item_cards.dart';

class HistorySubtaskArchiveCard extends StatelessWidget {
  const HistorySubtaskArchiveCard({
    required this.model,
    required this.showStartMargin,
    required this.canEdit,
    super.key,
  });

  final ReportSubtaskArchiveReadDto model;
  final bool showStartMargin;
  final bool canEdit;

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
    if (model.subtask?.dataSourceType == null) return;
    Get.find<SubtaskDatasource>().restore(
      dataSourceType: model.subtask!.dataSourceType!,
      id: model.subtask!.id,
      onResponse: (final response) {
        /// Refresh Reports Page
        if (Get.isRegistered<ProjectTaskReportsController>()) {
          Get.find<ProjectTaskReportsController>().onInit();
        }

        /// Refresh Subtask List Page
        if (Get.isRegistered<SubtaskListController>()) {
          Get.find<SubtaskListController>().onTryAgain();
        }
        if (Get.isRegistered<CreateUpdateTaskController>()) {
          Get.find<CreateUpdateTaskController>().onInit();
        }
      },
      onError: (final errorResponse) {},
    );
  }

  @override
  Widget build(final BuildContext context) {
    final subtask = model.subtask;

    final isArchived = model.isArchived;

    final bool haveAdminAccess = Get.find<PermissionService>().haveProjectAdminAccess;

    return baseCard(
      showStartMargin: showStartMargin,
      onTap: subtask == null
          ? null
          : () {
              bottomSheetWithNoScroll(
                title: s.details,
                backgroundColor: context.theme.cardColor,
                child: SubtaskDetailsPage(
                  subtask: subtask,
                  canManage: false,
                  canChange: false,
                  showAppBar: false,
                  showCheckBox: true,
                  onChangedCheckBoxStatus: (final model) {},
                  onEdited: (final model) {},
                  onDelete: () {},
                ),
              );
            },
      children: [
        baseHeader(context, model, showArrow: true),
        baseBodyText(context, model),
        if (subtask != null) ...[
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              WCircleAvatar(
                user: subtask.responsibleForDoing,
                size: 30,
              ),
              UImage(
                AppIcons.calendarOutline,
                size: 25,
                color: subtask.dateToStart != null ? context.theme.primaryColorDark : context.theme.hintColor,
              ),
              UBadge(
                badgeContent: Text(subtask.files.length.toString()).bodySmall(color: Colors.white),
                showBadge: subtask.files.isNotEmpty,
                child: UImage(
                  AppIcons.attachment,
                  size: 25,
                  color: subtask.files.isNotEmpty ? context.theme.primaryColorDark : context.theme.hintColor,
                ),
              ),
              UBadge(
                badgeContent: Text(subtask.links.length.toString()).bodySmall(color: Colors.white),
                showBadge: subtask.links.isNotEmpty,
                child: UImage(
                  AppIcons.linkOutline,
                  size: 25,
                  color: subtask.links.isNotEmpty ? context.theme.primaryColorDark : context.theme.hintColor,
                ),
              ),
              UBadge(
                badgeContent: Text(subtask.labels.length.toString()).bodySmall(color: Colors.white),
                showBadge: subtask.labels.isNotEmpty,
                child: UImage(
                  AppIcons.tagOutline,
                  size: 25,
                  color: subtask.labels.isNotEmpty ? context.theme.primaryColorDark : context.theme.hintColor,
                ),
              ),
            ],
          ),
          if (canEdit && isArchived && haveAdminAccess)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                UElevatedButton(
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
      ],
    );
  }
}
