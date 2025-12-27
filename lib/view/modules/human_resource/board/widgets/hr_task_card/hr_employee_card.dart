import 'package:flutter/cupertino.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/utils/enums/request_enums_extensions.dart';
import '../../../../../../core/utils/enums/request_enums.dart';
import '../../../../../../core/utils/extensions/request_extensions.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/theme.dart';
import '../../../../../../data/data.dart';
import 'hr_employee_card_controller.dart';

class WHREmployeeCard extends StatefulWidget {
  const WHREmployeeCard({
    required this.member,
    super.key,
  });

  final BoardMemberReadDto member;

  @override
  State<WHREmployeeCard> createState() => _WHREmployeeCardState();
}

class _WHREmployeeCardState extends State<WHREmployeeCard> with HrEmployeeCardController {
  final RxBool isExpanded = false.obs;

  @override
  void initState() {
    member = widget.member;
    initializeSubTasks();
    super.initState();
  }

  @override
  void dispose() {
    subTasks.close();
    isExpanded.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final WHREmployeeCard oldWidget) {
    if (oldWidget.member != widget.member) {
      setState(() {
        member = widget.member;
        initializeSubTasks();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(final BuildContext context) {
    return WCard(
      showBorder: true,
      onTap: navigateToProfile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                onPressed: removeMember,
                tooltip: s.removeMember,
                icon: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: CupertinoColors.systemGrey3,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(
                    Icons.close,
                    size: 15,
                    color: CupertinoColors.systemGrey3,
                  ),
                ),
              ),
              // WCheckBox(
              //   isChecked: false,
              //   onChanged: (final value) => removeMember(),
              // ),
              WCircleAvatar(
                user: UserReadDto(
                  id: member.userId.toString(),
                  fullName: member.fullName,
                  avatar: member.avatar,
                  avatarUrl: member.avatar?.url,
                ),
                showFullName: true,
                maxLines: 2,
                size: 40,
              ).expanded(),
            ],
          ),

          if (!member.isAccepted)
            WLabel(
              minWidth: context.width,
              text: s.pendingInvitation,
              color: AppColors.orange,
            ).marginOnly(top: 12),

          // دکمه نمایش/مخفی کردن درخواست‌ها
          Obx(() => Container(
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
                    '${s.requests} (${subTasks.length})',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              )),

          // لیست ساب تسک‌ها
          Obx(() => AnimatedSize(
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
                              TextButton.icon(
                                style: ButtonStyle(
                                  overlayColor: WidgetStatePropertyAll(context.theme.hintColor.withAlpha(20)),
                                ),
                                onPressed: navigateToCreateRequestPage,
                                icon: Icon(Icons.add_rounded, size: 20, color: context.theme.primaryColor),
                                label: Text(s.newRequest).bodyMedium(color: context.theme.primaryColor),
                              ),
                              ...subTasks.map((final subTask) => _buildSubTaskItem(subTask)),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSubTaskItem(final HRSubTask request) {
    return WCard(
      onTap: () => navigateToRequestDetails(request),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: 6,
      color: context.isDarkMode ? Colors.white10 : Colors.grey[50],
      showBorder: true,
      borderColor: request.assignedTo.isEmpty ? AppColors.orange : null,
      child: Row(
        spacing: 10,
        children: [
          WCheckBox(
            isChecked: !request.status.isPending(),
            onChanged: (final value) {
              final isAmongAcceptors = request.assignedTo.any((final e) => e.user.id == Get.find<Core>().userReadDto.value.id);
              if (!isAmongAcceptors) return AppNavigator.snackbarRed(title: s.error, subtitle: s.notAllowChangeStatus);
              toggleRequestStatus(request);
            },
          ),
          Expanded(
            child: Text(
              request.title,
              maxLines: 2,
              style: context.textTheme.bodyMedium?.copyWith(
                decoration: request.status.isPending() ? null : TextDecoration.lineThrough,
                color: request.status.isPending() ? null : context.theme.hintColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (request.assignedTo.isNotEmpty)
            WOverlappingAvatarRow(
              users: request.assignedTo.map((final e) => e.user).toList(),
              maxVisibleAvatars: 2,
            )
          else
            const UImage(AppIcons.info, size: 35, color: AppColors.orange),
        ],
      ),
    );
  }
}

// مدل ساب تسک
class HRSubTask {
  final String slug;
  final String title;
  final StatusType status;
  final UserReadDto? requestedBy;
  final List<AcceptorUserReadDto> assignedTo;
  final IRequestReadDto request;

  HRSubTask({
    required this.slug,
    required this.title,
    required this.status,
    required this.request,
    this.requestedBy,
    this.assignedTo = const [],
  });

  HRSubTask copyWith({
    final String? slug,
    final String? title,
    final StatusType? status,
    final UserReadDto? requestedBy,
    final List<AcceptorUserReadDto>? assignedTo,
    final IRequestReadDto? request,
  }) {
    return HRSubTask(
      slug: slug ?? this.slug,
      title: title ?? this.title,
      status: status ?? this.status,
      requestedBy: requestedBy ?? this.requestedBy,
      assignedTo: assignedTo ?? this.assignedTo,
      request: request ?? this.request,
    );
  }

  factory HRSubTask.fromModel(final IRequestReadDto model) => HRSubTask(
        slug: model.slug.toString(),
        title: model.getTitle(),
        status: model.status ?? StatusType.pending,
        requestedBy: model.requestingUser,
        assignedTo: model.reviewerUsers,
        request: model,
      );
}
