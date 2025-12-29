import 'package:bermooda_business/view/modules/legal/legal_case/legal_case_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../widgets.dart';
import '../../image_files.dart';
import '../../time_tracking/time_tracking.dart';
import '../../../core.dart';
import '../../../theme.dart';
import '../../../utils/enums/enums.dart';
import '../../../../data/data.dart';
import '../../../../view/modules/crm/customer/customer_page.dart';
import '../edit_follow_up/edit_follow_up_form.dart';
import '../follow_up_card_controller.dart';

class FollowUpDetailsPage extends StatefulWidget {
  const FollowUpDetailsPage({
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

  @override
  State<FollowUpDetailsPage> createState() => _FollowUpDetailsPageState();
}

class _FollowUpDetailsPageState extends State<FollowUpDetailsPage> with FollowUpCardController {
  bool get canManage =>
      widget.canManage &&
      haveAccess &&
      !followUp.value.isFollowed &&
      !followUp.value.isDeleted &&
      (isMyFollowUp || haveAdminAccess);

  bool get showTimerButtons => widget.canManage && !followUp.value.isFollowed && isMyFollowUp && haveAccess;

  @override
  void initState() {
    initialController(
      followUp: widget.followUp,
    );
    super.initState();
  }

  @override
  void dispose() {
    disposeItems();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      color: context.theme.cardColor,
      appBar: widget.showAppBar
          ? AppBar(
              actions: [
                /// More Button
                Obx(
                  () {
                    if (!followUp.value.isFollowed && canManage) {
                      return const Icon(Icons.more_vert_rounded).showMenus([
                        WPopupMenuItem(
                          title: s.edit,
                          titleColor: AppColors.green,
                          icon: AppIcons.editOutline,
                          iconColor: AppColors.green,
                          onTap: () {
                            final oldModel = followUp.value.copyWith();

                            bottomSheet(
                              title: s.editFollowUp,
                              child: EditFollowUpForm(
                                model: followUp.value,
                                onResponse: (final newModel) {
                                  followUp(newModel);
                                  widget.onChanged(followUp.value);
                                  handleMyFollowUpsChanges(oldModel, newModel);
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
                          onTap: () => delete(onResponse: widget.onDelete),
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
                      if (haveAccess)
                        WCheckBox(
                          isChecked: followUp.value.isFollowed, // Current checked state
                          onChanged: (final value) {
                            if (canManage) {
                              onTapFollowUpCheckBox(followUp: followUp.value, onResponse: widget.onChanged);
                            }
                          },
                        ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (followUp.value.time != null)
                            Text(
                              followUp.value.time ?? '',
                              textAlign: TextAlign.justify,
                            ).titleMedium(),
                          Text(
                            followUp.value.date?.formatCompactDate() ?? '',
                            textAlign: TextAlign.justify,
                          ).titleMedium(),
                        ],
                      ).expanded(),
                    ],
                  ).marginOnly(top: 24),
                  _item(
                    title: s.assignee,
                    icon: UImage(AppIcons.userOctagonOutline, size: 25, color: context.theme.hintColor),
                    value: WCircleAvatar(user: followUp.value.assignedUser, size: 30, showFullName: true),
                  ),
                  /// Customer data
                  if (widget.showSourceData && followUp.value.customerData != null)
                    _item(
                      title: s.customer,
                      icon: UImage(AppIcons.userOutline, size: 25, color: context.theme.hintColor),
                      value: WTextButton2(
                        text: followUp.value.customerData?.fullNameOrCompanyName ?? '- -',
                        onPressed: () {
                          if (followUp.value.customerData == null) return;
                          UNavigator.off(
                            CustomerPage(
                              customer: followUp.value.customerData!,
                              onEdit: (final customer) {
                                followUp.value = followUp.value.copyWith(
                                  customerData: CustomerData(
                                    id: customer.id,
                                    fullNameOrCompanyName: customer.fullNameOrCompanyName,
                                    amount: customer.amount,
                                    connectionType: customer.connectionType,
                                  ),
                                );
                                widget.onChanged(followUp.value);
                              },
                              onDelete: (final customer) {
                                followUp.value = followUp.value.copyWith(customerData: null);
                                widget.onChanged(followUp.value);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  /// Legal Case data
                  if (widget.showSourceData && followUp.value.caseData != null)
                    _item(
                      title: s.legalCase,
                      icon: Icon(CupertinoIcons.folder, size: 25, color: context.theme.hintColor),
                      value: WTextButton2(
                        text: followUp.value.caseData?.title ?? '- -',
                        onPressed: () {
                          if (followUp.value.caseData == null) return;
                          UNavigator.off(
                            LegalCasePage(
                              legalCase: followUp.value.caseData!,
                              canEdit: true,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ).pSymmetric(horizontal: 16),

              /// Timer
              if (followUp.value.timer != null) const Divider(),
              if (followUp.value.timer != null)
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
                        timerDto: followUp.value.timer!,
                        showButtons: showTimerButtons,
                        onTapButton: (final command) {
                          if (command == TimerStatusCommand.stop) {
                            onTapFollowUpCheckBox(followUp: followUp.value, onResponse: widget.onChanged);
                          } else {
                            changedTimerStatus(command: command, onChangedTimer: widget.onChanged);
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
                          child: Text(followUp.value.files.length.toString()).bodyMedium(color: context.theme.hintColor),
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
                child: followUp.value.files.isNotEmpty
                    ? WImageFiles(
                        files: followUp.value.files,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _item({
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
