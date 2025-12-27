import 'package:bermooda_business/core/utils/extensions/user_permission_extensions.dart';
import 'package:u/utilities.dart';

import '../../../../core/navigator/navigator.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import '../departments/create_update/department_create_update_page.dart';
import '../departments/hr_departments_list_controller.dart';
import '../hr_department_main_page.dart';

class WDepartmentItemCard extends StatefulWidget {
  const WDepartmentItemCard({
    required this.department,
    required this.ctrl,
    required this.isReorderEnabled,
    required this.showMoreIcon,
    required this.index,
    super.key,
  });

  final HRDepartmentReadDto department;
  final HrDepartmentsListController ctrl;
  final bool isReorderEnabled;
  final bool showMoreIcon;
  final int index;

  @override
  State<WDepartmentItemCard> createState() => _WDepartmentItemCardState();
}

class _WDepartmentItemCardState extends State<WDepartmentItemCard> with SingleTickerProviderStateMixin {
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

    // بر اساس وضعیت اولیه، انیمیشن را اجرا کن
    if (widget.isReorderEnabled) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant final WDepartmentItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.department != widget.department || oldWidget.showMoreIcon != widget.showMoreIcon || oldWidget.index != widget.index) {
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
      onTap: () {
        if (widget.isReorderEnabled) return AppNavigator.snackbarRed(title: s.warning, subtitle: s.saveYourChangesFirst);

        bottomSheet(
          child: HrDepartmentMainPage(
            department: widget.department,
            onEdited: (final department) => widget.ctrl.departments[widget.index] = department,
          ),
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
                  Flexible(child: Text(widget.department.title ?? '', maxLines: 1).bodyMedium(overflow: TextOverflow.ellipsis).bold()),
                ],
              ).expanded(),
              if (widget.showMoreIcon)
                SizeTransition(
                  sizeFactor: Tween<double>(begin: 1.0, end: 0.0).animate(_animation),
                  axis: Axis.horizontal,
                  child: Container(
                    width: 35,
                    height: 35,
                    color: Colors.transparent,
                    child: Icon(Icons.more_vert_rounded, color: context.theme.hintColor),
                  ).showMenus([
                    WPopupMenuItem(
                      title: s.edit,
                      icon: AppIcons.editOutline,
                      titleColor: AppColors.green,
                      iconColor: AppColors.green,
                      onTap: () {
                        bottomSheet(
                          title: s.editDepartment,
                          child: DepartmentCreateUpdatePage(department: widget.department),
                        );
                      },
                    ),
                    // WPopupMenuItem(
                    //   title: s.delete,
                    //   icon: AppIcons.delete,
                    //   titleColor: AppColors.red,
                    //   iconColor: AppColors.red,
                    //   onTap: () => widget.ctrl.deleteFolder(widget.department),
                    // ),
                  ]),
                ),
            ],
          ),
          WLabelProgressBar(title: s.successRate, value: widget.department.progress, progressColor: AppColors.green, minTextWidth: 60),
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
                            subtitle: Text(member.permissions.getByName(PermissionName.humanResources)?.permissionType?.getTitle() ?? '')
                                .bodySmall(color: context.theme.hintColor),
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
}
