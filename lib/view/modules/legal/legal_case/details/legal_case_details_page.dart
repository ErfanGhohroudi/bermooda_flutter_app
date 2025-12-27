import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import 'legal_case_details_controller.dart';
import 'widgets/document_item.dart';

class LegalCaseDetailsPage extends StatefulWidget {
  const LegalCaseDetailsPage({
    required this.legalCaseId,
    required this.canEdit,
    super.key,
  });

  final int legalCaseId;
  final bool canEdit;

  @override
  State<LegalCaseDetailsPage> createState() => _LegalCaseDetailsPageState();
}

class _LegalCaseDetailsPageState extends State<LegalCaseDetailsPage> {
  late final LegalCaseDetailsController ctrl;

  @override
  void initState() {
    ctrl = Get.put(
      LegalCaseDetailsController(
        legalCaseId: widget.legalCaseId,
        canEdit: widget.canEdit,
      ),
    );
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Obx(
      () {
        if (ctrl.pageState.isInitial() || ctrl.pageState.isLoading()) {
          return const Center(child: WCircularLoading());
        }

        if (ctrl.pageState.isError()) {
          return Center(child: WErrorWidget(onTapButton: ctrl.onTryAgain));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              _header(),
              // /// Steps
              // if (ctrl.legalCase.value.steps.isNotEmpty)
              //   LegalCaseSteps(legalCase: ctrl.legalCase.value, onStepChanged: ctrl.updateLegalCase).marginOnly(top: 16),
              const Divider(),
              _buildSection(
                title: s.steps,
                icon: AppIcons.tickCircleOutline,
                iconColor: AppColors.purple,
                headerTrailing: ctrl.haveAdminAccess
                    ? TextButton.icon(
                        onPressed: ctrl.showCreateStepBottomSheet,
                        label: Text(s.addText).bodyMedium(color: Colors.white),
                        icon: const UImage(AppIcons.addSquareOutline, color: Colors.white, size: 20),
                        style: TextButton.styleFrom(backgroundColor: AppColors.purple),
                      )
                    : null,
                child: _buildStepsList(),
              ),
              _buildSection(
                title: s.documents,
                icon: AppIcons.fileOutline,
                iconColor: AppColors.blue,
                headerTrailing: ctrl.haveAdminAccess
                    ? TextButton.icon(
                        onPressed: ctrl.showCreateDocumentBottomSheet,
                        label: Text(s.addText).bodyMedium(color: Colors.white),
                        icon: const UImage(AppIcons.addSquareOutline, color: Colors.white, size: 20),
                        style: TextButton.styleFrom(backgroundColor: AppColors.blue),
                      )
                    : null,
                child: Stack(
                  children: [
                    Obx(
                      () {
                        if (ctrl.documents.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: Text(s.noData).bodyMedium(color: context.theme.hintColor)),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Obx(
                      () => ListView.builder(
                        itemCount: ctrl.documents.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (final context, final index) {
                          final document = ctrl.documents[index];
                          return WDocumentItem(
                            document: document,
                            controller: ctrl,
                            canEdit: ctrl.canEdit,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header() => Obx(
    () => WCard(
      showBorder: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Row(
            spacing: 10,
            children: [
              Row(
                spacing: 12,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.brown.withValues(alpha: 0.2),
                    radius: 20,
                    child: const Icon(CupertinoIcons.folder_fill, color: AppColors.brown, size: 20),
                  ),
                  Text(ctrl.legalCase.value.title ?? '- -').titleMedium(),
                ],
              ).expanded(),
              if (ctrl.canEdit)
                Icon(Icons.more_vert_rounded, color: context.theme.hintColor).showMenus([
                  WPopupMenuItem(
                    title: s.edit,
                    icon: AppIcons.editOutline,
                    iconColor: AppColors.green,
                    titleColor: AppColors.green,
                    onTap: ctrl.showUpdateLegalCaseBottomSheet,
                  ),
                  WPopupMenuItem(
                    title: s.delete,
                    icon: AppIcons.delete,
                    iconColor: AppColors.red,
                    titleColor: AppColors.red,
                    onTap: ctrl.onDeleteLegalCase,
                  ),
                ]),
            ],
          ),
          Row(
            spacing: 5,
            children: [
              Text("${s.description}:").bodyMedium(color: context.theme.hintColor),
              Flexible(child: Text(ctrl.legalCase.value.description ?? '- -').bodyMedium()),
            ],
          ).pSymmetric(vertical: 8),
        ],
      ),
    ),
  );

  Widget _buildStepsList() {
    if (ctrl.haveAdminAccess) {
      return ReorderableListView.builder(
        itemCount: ctrl.steps.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        onReorder: ctrl.reorderSteps,
        itemBuilder: (final context, final index) {
          final step = ctrl.steps[index];
          final canReorder = ctrl.canReorderStep(step);
          final isCompleted = step.isCompleted;

          return ListTile(
            key: ValueKey(step.id),
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 2,
            leading: canReorder
                ? ReorderableDragStartListener(
                    index: index,
                    child: Icon(Icons.drag_indicator_rounded, size: 30, color: context.theme.hintColor),
                  )
                : Icon(
                    Icons.drag_indicator_rounded,
                    size: 30,
                    color: context.theme.hintColor.withValues(alpha: 0.3),
                  ),
            title: Row(
              spacing: 6,
              children: [
                WCheckBox(
                  isChecked: isCompleted,
                  onChanged: (final value) => ctrl.toggleStepStatus(step, value),
                ),
                _buildStepTitle(step.title, isCompleted).expanded(),
                WMoreButtonIcon(
                  items: [
                    WPopupMenuItem(
                      title: s.edit,
                      icon: AppIcons.editOutline,
                      titleColor: AppColors.green,
                      iconColor: AppColors.green,
                      onTap: () => ctrl.showUpdateStepBottomSheet(step),
                    ),
                    WPopupMenuItem(
                      title: s.delete,
                      icon: AppIcons.delete,
                      titleColor: AppColors.red.withValues(alpha: isCompleted == false ? 1 : 0.3),
                      iconColor: AppColors.red.withValues(alpha: isCompleted == false ? 1 : 0.3),
                      onTap: () {
                        if (isCompleted == false) {
                          ctrl.deleteStep(step);
                        } else {
                          AppNavigator.snackbarRed(title: s.error, subtitle: s.cannotDeleteCompletedSteps);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return ListView.builder(
      itemCount: ctrl.steps.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (final context, final index) {
        final step = ctrl.steps[index];
        final isCompleted = step.isCompleted;

        return ListTile(
          key: ValueKey(step.id),
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 2,
          leading: const SizedBox(width: 30),
          title: Row(
            spacing: 6,
            children: [
              WCheckBox(
                isChecked: isCompleted,
                onChanged: (_) {},
              ),
              _buildStepTitle(step.title, isCompleted).expanded(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepTitle(final String? title, final bool isCompleted) {
    return Text(
      title ?? '- -',
      maxLines: 1,
    ).bodyMedium(
      overflow: TextOverflow.ellipsis,
      color: isCompleted ? context.theme.primaryColorDark.withValues(alpha: 0.5) : null,
      decoration: isCompleted ? TextDecoration.lineThrough : null,
    );
  }

  Widget _buildSection({
    required final String icon,
    required final Color iconColor,
    required final String title,
    required final Widget child,
    final Widget? headerTrailing,
  }) {
    return WCard(
      showBorder: true,
      color: iconColor.withValues(alpha: 0.05),
      borderColor: iconColor.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            children: [
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: UImage(icon, color: iconColor),
              ),
              Expanded(child: Text(title).bodyMedium()),
              ?headerTrailing,
            ],
          ),
          const Divider(),
          child,
        ],
      ),
    );
  }
}
