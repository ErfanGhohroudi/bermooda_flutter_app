import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/widgets/image_files.dart';
import '../../../../../core/widgets/time_tracking/time_tracking.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../../crm/customer/customer_page.dart';
import '../../../legal/legal_case/legal_case_page.dart';
import '../sheets/edit_follow_up_sheet.dart';
import '../controllers/follow_up_card_controller.dart';

class FollowUpDetailsPage extends StatelessWidget {
  const FollowUpDetailsPage({
    required this.ctrl,
    required this.followUp,
    required this.onChanged,
    required this.onDelete,
    this.showSourceData = true,
    this.canManage = true,
    this.showAppBar = true,
    super.key,
  });

  final FollowUpReadDto followUp;
  final Function(FollowUpReadDto model) onChanged;
  final VoidCallback onDelete;
  final bool showSourceData;
  final bool canManage;
  final bool showAppBar;

  final FollowUpCardController ctrl;

  bool get _canManage =>
      canManage &&
      ctrl.haveAccess &&
      !ctrl.followUp.value.isFollowed &&
      !ctrl.followUp.value.isDeleted &&
      (ctrl.isMyFollowUp || ctrl.haveAdminAccess);

  bool get showTimerButtons => _canManage && !ctrl.followUp.value.isFollowed && ctrl.isMyFollowUp && ctrl.haveAccess;

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      color: context.theme.cardColor,
      appBar: showAppBar
          ? AppBar(
              actions: [
                /// More Button
                Obx(
                  () {
                    if (!ctrl.followUp.value.isFollowed && _canManage) {
                      return const Icon(Icons.more_vert_rounded).showMenus([
                        WPopupMenuItem(
                          title: s.edit,
                          titleColor: AppColors.green,
                          icon: AppIcons.editOutline,
                          iconColor: AppColors.green,
                          onTap: () {
                            final oldModel = ctrl.followUp.value.copyWith();

                            bottomSheet(
                              title: s.editFollowUp,
                              child: EditFollowUpSheet(
                                model: ctrl.followUp.value,
                                onResponse: (final newModel) {
                                  ctrl.followUp(newModel);
                                  onChanged(ctrl.followUp.value);
                                  ctrl.handleMyFollowUpsChanges(oldModel, newModel);
                                },
                              ),
                            );
                          },
                        ),
                        WPopupMenuItem(
                          title: s.delete,
                          titleColor: AppColors.red,
                          icon: AppIcons.delete,
                          iconColor: AppColors.red,
                          onTap: () => ctrl.delete(onResponse: onDelete),
                        ),
                      ]);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(width: 10),
              ],
            )
          : null,
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 18,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      if (ctrl.haveAccess)
                        WCheckBox(
                          isChecked: ctrl.followUp.value.isFollowed, // Current checked state
                          onChanged: (final value) {
                            if (_canManage) {
                              ctrl.onTapFollowUpCheckBox(followUp: ctrl.followUp.value, onResponse: onChanged);
                            }
                          },
                        ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (ctrl.followUp.value.time != null)
                            Text(
                              ctrl.followUp.value.time ?? '',
                              textAlign: TextAlign.justify,
                            ).titleMedium(),
                          Text(
                            ctrl.followUp.value.date?.formatCompactDate() ?? '',
                            textAlign: TextAlign.justify,
                          ).titleMedium(),
                        ],
                      ).expanded(),
                    ],
                  ).marginOnly(top: 24),
                  _item(
                    context,
                    title: s.assignee,
                    icon: UImage(AppIcons.userOctagonOutline, size: 25, color: context.theme.hintColor),
                    value: WCircleAvatar(user: ctrl.followUp.value.assignedUser, size: 30, showFullName: true),
                  ),

                  /// Customer data
                  if (showSourceData && ctrl.followUp.value.customerData != null)
                    _item(
                      context,
                      title: s.customer,
                      icon: UImage(AppIcons.userOutline, size: 25, color: context.theme.hintColor),
                      value: WTextButton2(
                        text: ctrl.followUp.value.customerData?.fullNameOrCompanyName ?? '- -',
                        onPressed: () {
                          if (ctrl.followUp.value.customerData == null) return;
                          AppNavigator.off(
                            CustomerPage(
                              customer: ctrl.followUp.value.customerData!,
                              onEdit: (final customer) {
                                ctrl.followUp.value = ctrl.followUp.value.copyWith(
                                  customerData: CustomerData(
                                    id: customer.id,
                                    fullNameOrCompanyName: customer.fullNameOrCompanyName,
                                    amount: customer.amount,
                                    connectionType: customer.connectionType,
                                  ),
                                );
                                onChanged(ctrl.followUp.value);
                              },
                              onDelete: (final customer) {
                                ctrl.followUp.value = ctrl.followUp.value.copyWith(customerData: null);
                                onChanged(ctrl.followUp.value);
                              },
                            ),
                          );
                        },
                      ),
                    ),

                  /// Legal Case data
                  if (showSourceData && ctrl.followUp.value.caseData != null)
                    _item(
                      context,
                      title: s.legalCase,
                      icon: Icon(CupertinoIcons.folder, size: 25, color: context.theme.hintColor),
                      value: WTextButton2(
                        text: ctrl.followUp.value.caseData?.title ?? '- -',
                        onPressed: () {
                          if (ctrl.followUp.value.caseData == null) return;
                          AppNavigator.off(
                            LegalCasePage(
                              legalCase: ctrl.followUp.value.caseData!,
                              canEdit: true,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ).pSymmetric(horizontal: 16),

              /// Timer
              if (ctrl.followUp.value.timer != null) const Divider(),
              if (ctrl.followUp.value.timer != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        UImage(AppIcons.timerOutline, size: 25, color: context.theme.hintColor),
                        Text(s.timeTracking).bodyMedium(color: context.theme.hintColor),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 35),
                      child: WTimeTracking(
                        timerDto: ctrl.followUp.value.timer!,
                        showButtons: showTimerButtons,
                        onTapButton: (final command) {
                          if (command == TimerStatusCommand.stop) {
                            ctrl.onTapFollowUpCheckBox(followUp: ctrl.followUp.value, onResponse: onChanged);
                          } else {
                            ctrl.changedTimerStatus(command: command, onChangedTimer: onChanged);
                          }
                        },
                      ),
                    ),
                  ],
                ).pSymmetric(horizontal: 16),
              const Divider(),
              WExpansionTile(
                title: s.files,
                showDivider: false,
                titleWidget: Row(
                  spacing: 16,
                  children: [
                    Flexible(child: Text(s.files).bodyMedium(color: context.theme.hintColor)),
                    UBadge(
                      badgeContent: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                        child: Center(
                          child: Text(ctrl.followUp.value.files.length.toString()).bodyMedium(color: context.theme.hintColor),
                        ),
                      ),
                      badgeColor: context.theme.hintColor.withAlpha(100),
                    ),
                  ],
                ),
                icon: AppIcons.attachment,
                titleColor: context.theme.hintColor,
                iconColor: context.theme.hintColor,
                startPadding: 0,
                child: ctrl.followUp.value.files.isNotEmpty
                    ? WImageFiles(
                        files: ctrl.followUp.value.files,
                        removable: false,
                        showUploadWidget: false,
                        onFilesUpdated: (final list) {},
                        uploadingFileStatus: (final value) {},
                      )
                    : SizedBox(
                        height: 70,
                        child: Center(child: Text(s.listIsEmpty).bodyMedium(color: context.theme.hintColor)),
                      ),
                onChanged: (final value) {},
              ).pSymmetric(horizontal: 16),
              const Divider(),
              UElevatedButton(
                title: s.sendSMS,
                icon: const UImage(AppIcons.chatOutline, color: Colors.white, size: 20),
                backgroundColor: AppColors.green,
                onTap: ctrl.showSendSmsBottomSheet,
              ).pSymmetric(horizontal: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    final BuildContext context, {
    required final String title,
    required final Widget value,
    final Widget? icon,
    final CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) => Row(
    crossAxisAlignment: crossAxisAlignment,
    spacing: 10,
    children: [
      SizedBox(
        width: context.width / 3.5,
        child: Row(
          spacing: 10,
          children: [
            if (icon != null) icon,
            Flexible(
              child: Text(title).bodyMedium(color: context.theme.hintColor),
            ),
          ],
        ),
      ),
      value.expanded(),
    ],
  );
}
