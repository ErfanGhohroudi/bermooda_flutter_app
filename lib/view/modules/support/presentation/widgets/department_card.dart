import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/extensions/user_permission_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../domain/entities/support_department.dart';
import '../controllers/department_list_controller.dart';
import '../pages/department_create_update_page.dart';
import '../sheets/support_department_main_sheet.dart';

class WSupportDepartmentCard extends StatefulWidget {
  const WSupportDepartmentCard({
    required this.department,
    required this.isReorderEnabled,
    required this.showMoreIcon,
    required this.index,
    this.ctrl,
    this.moreButtonItems,
    this.onTap,
    super.key,
  });

  final SupportDepartment department;
  final bool isReorderEnabled;
  final bool showMoreIcon;
  final int index;
  final SupportDepartmentListController? ctrl;
  final List<PopupMenuEntry>? moreButtonItems;
  final VoidCallback? onTap;

  @override
  State<WSupportDepartmentCard> createState() => _WSupportDepartmentCardState();
}

class _WSupportDepartmentCardState extends State<WSupportDepartmentCard> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (widget.isReorderEnabled) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant final WSupportDepartmentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.department != widget.department ||
        oldWidget.showMoreIcon != widget.showMoreIcon ||
        oldWidget.index != widget.index) {
      setState(() {});
    }
    if (widget.isReorderEnabled != oldWidget.isReorderEnabled) {
      if (widget.isReorderEnabled) {
        _animationController.forward(); // Show
      } else {
        _animationController.reverse(); // Hide
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return WCard(
      showBorder: true,
      onTap:
          widget.onTap ??
          () {
            if (widget.isReorderEnabled) return AppSnackBar.snackbarRed(title: s.warning, subtitle: s.saveYourChangesFirst);

            bottomSheet(
              child: SupportDepartmentMainSheet(department: widget.department),
            );
          },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Row(
            spacing: 10,
            children: [
              SizeTransition(
                sizeFactor: _animation,
                axis: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ReorderableDragStartListener(
                      index: widget.index,
                      child: UImage(AppIcons.arrowSwapVert, size: 30, color: context.theme.hintColor),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              Row(
                spacing: 10,
                children: [
                  WCircleAvatar(
                    user: UserReadDto(id: '', avatarUrl: widget.department.avatar?.url, fullName: widget.department.title),
                    size: 50,
                  ),
                  Flexible(child: Text(widget.department.title, maxLines: 1).bodyMedium(overflow: TextOverflow.ellipsis).bold()),
                ],
              ).expanded(),
              if (widget.showMoreIcon)
                SizeTransition(
                  sizeFactor: Tween<double>(begin: 1.0, end: 0.0).animate(_animation),
                  axis: Axis.horizontal,
                  child: WMoreButtonIcon(
                    items:
                        widget.moreButtonItems ??
                        [
                          WPopupMenuItem(
                            title: s.edit,
                            icon: AppIcons.editOutline,
                            titleColor: AppColors.green,
                            iconColor: AppColors.green,
                            onTap: () {
                              if (widget.ctrl == null) return;
                              bottomSheet(
                                title: s.editDepartment,
                                child: SupportDepartmentCreateUpdatePage(
                                  ctrl: widget.ctrl!,
                                  department: widget.department,
                                ),
                              );
                            },
                          ),
                          WPopupMenuItem(
                            title: s.archive,
                            icon: AppIcons.archiveOutline,
                            titleColor: AppColors.red,
                            iconColor: AppColors.red,
                            onTap: () => widget.ctrl?.archiveDepartment(widget.department),
                          ),
                        ],
                  ),
                ),
            ],
          ),
          const Divider(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _item(
                title: "s.totalChats",
                value: widget.department.totalChats.toString().separateNumbers3By3(),
                color: AppColors.blue,
              ).expanded(),
              _item(
                title: "s.openChats",
                value: widget.department.openChats.toString().separateNumbers3By3(),
                color: AppColors.red,
              ).expanded(),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _item(
                title: "s.waitingForReply",
                value: widget.department.waitingForReply.toString().separateNumbers3By3(),
                color: AppColors.orange,
              ).expanded(),
              _item(
                title: "s.closedChats",
                value: widget.department.closedChats.toString().separateNumbers3By3(),
                color: Colors.green,
              ).expanded(),
            ],
          ),
          if (widget.department.members.isNotEmpty) ...[
            const Divider(height: 0),
            InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                bottomSheet(
                  title: s.members,
                  child: Column(
                    children: List.generate(
                      widget.department.members.length,
                      (final index) {
                        final member = widget.department.members[index];
                        return WCard(
                          showBorder: true,
                          child: ListTile(
                            minTileHeight: 20,
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.zero,
                            leading: WCircleAvatar(user: member, size: 40),
                            title: Text(member.fullName ?? '- -').bodyMedium(),
                            subtitle: Text(
                              member.permissions.getByName(PermissionName.support)?.permissionType?.getTitle() ?? '',
                            ).bodySmall(color: context.theme.hintColor),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WOverlappingAvatarRow(
                    users: widget.department.members,
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: context.theme.hintColor, size: 20),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _item({
    required final String title,
    required final String value,
    final Color? color,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(title, textAlign: TextAlign.center).bodyMedium(color: context.theme.hintColor),
      Text(value, textAlign: TextAlign.center).titleMedium(color: color).bold(),
    ],
  );
}
