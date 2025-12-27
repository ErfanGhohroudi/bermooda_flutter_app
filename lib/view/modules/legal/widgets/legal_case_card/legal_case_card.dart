import 'package:u/utilities.dart';

import '../../../../../core/widgets/follow_up_card/follow_up_card.dart';
import '../../../../../core/widgets/subtask_card/subtask_card_compact.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';
import '../legal_case_steps.dart';
import 'legal_case_card_controller.dart';

class WLegalCaseCard extends StatefulWidget {
  const WLegalCaseCard({
    required this.legalCase,
    this.isArchived = false,
    this.onRestore,
    super.key,
  });

  final LegalCaseReadDto legalCase;
  final bool isArchived;
  final VoidCallback? onRestore;

  @override
  State<WLegalCaseCard> createState() => _WLegalCaseCardState();
}

class _WLegalCaseCardState extends State<WLegalCaseCard> with LegalCaseCardController {
  final RxBool isExpanded = false.obs;

  @override
  void initState() {
    initializeController(legalCase: widget.legalCase);
    super.initState();
  }

  @override
  void dispose() {
    tasks.close();
    isExpanded.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WLegalCaseCard oldWidget) {
    if (oldWidget.legalCase != widget.legalCase) {
      initializeController(legalCase: widget.legalCase);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return WCard(
      showBorder: true,
      onTap: widget.isArchived ? null : navigateToLegalCasePage,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header
            Row(
              spacing: 12,
              children: [
                if (!widget.isArchived)
                  WCheckBox(
                    isChecked: false,
                    onChanged: widget.isArchived ? (_) {} : (final value) => onTapCheckBox(),
                  ),
                Expanded(child: Text(legalCase.value.title ?? '- -').titleMedium()),
                WMoreButtonIcon(
                  items: [
                    if (widget.isArchived == false)
                      WPopupMenuItem(
                        title: s.delete,
                        icon: AppIcons.delete,
                        titleColor: AppColors.red,
                        iconColor: AppColors.red,
                        onTap: onDeleteLegalCase,
                      ),
                    if (widget.isArchived == true)
                      WPopupMenuItem(
                        title: s.restore,
                        icon: AppIcons.restore,
                        onTap: () => widget.onRestore?.call(),
                      ),
                  ],
                ),
              ],
            ),

            /// Contract
            if (legalCase.value.contract != null)
              WCard(
                color: legalCase.value.contract!.status.color.withValues(alpha: 0.1),
                margin: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    Row(
                      spacing: 5,
                      children: [
                        Expanded(child: Text(legalCase.value.contract!.title ?? '').bodyMedium()),
                        WLabel(
                          text: legalCase.value.contract!.status.getTitle(),
                          color: legalCase.value.contract!.status.color,
                        ),
                      ],
                    ),
                    if (legalCase.value.contract!.signers.isNotEmpty)
                      Row(
                        spacing: 5,
                        children: [
                          Text("${s.parties}:").bodySmall(),
                          Text(
                            "${legalCase.value.contract!.signers.length.toString().separateNumbers3By3()}"
                            " "
                            "${!isPersianLang && legalCase.value.contract!.signers.length == 1 ? s.user.removeLast() : s.user}",
                          ).bodySmall(),
                        ],
                      ),
                  ],
                ),
              ),

            /// Steps
            if (legalCase.value.steps.isNotEmpty)
              LegalCaseSteps(legalCase: legalCase.value, onStepChanged: onStepChanged).marginOnly(top: 16),

            if (tasks.isNotEmpty) ...[
              /// Expansion List Button
              Obx(
                () => Container(
                  width: context.width,
                  margin: const EdgeInsets.only(top: 8),
                  child: TextButton.icon(
                    style: ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(context.theme.hintColor.withAlpha(20)),
                    ),
                    onPressed: () => isExpanded.value = !isExpanded.value,
                    icon: Icon(
                      isExpanded.value ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                    ),
                    label: Text(
                      '${s.todo} (${tasks.length})',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),

              /// Tasks List
              Obx(
                () => AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.center,
                  curve: Curves.easeInOutExpo,
                  child: SizedBox(
                    width: double.infinity,
                    child: AnimatedSwitcher(
                      duration: 500.milliseconds,
                      child: isExpanded.value
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(height: 0).marginOnly(bottom: 10),
                                ...tasks.map((final task) => _buildTaskItem(task)),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ] else
              const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(final dynamic item) {
    if (item is FollowUpReadDto) {
      return WFollowUpCard(
        followUp: item,
        shape: FollowUpCardShape.compact,
        onChanged: (final model) {},
        onDelete: () {},
      );
    } else if (item is SubtaskReadDto) {
      return WSubtaskCardCompact(
        subtask: item,
        onChangedStatus: (final model) {},
      );
    }
    return const SizedBox.shrink();
  }
}
