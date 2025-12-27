import 'package:u/utilities.dart';

import '../../../../core/utils/extensions/user_permission_extensions.dart';
import '../../../../core/navigator/navigator.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/core.dart';
import '../../../../core/theme.dart';
import '../../../../data/data.dart';
import '../legal_department_main_page.dart';
import '../departments/legal_department_list_controller.dart';

class WLegalDepartmentItemCard extends StatefulWidget {
  const WLegalDepartmentItemCard({
    required this.department,
    required this.ctrl,
    required this.isReorderEnabled,
    required this.index,
    super.key,
  });

  final LegalDepartmentReadDto department;
  final LegalDepartmentListController ctrl;
  final bool isReorderEnabled;
  final int index;

  @override
  State<WLegalDepartmentItemCard> createState() => _WLegalDepartmentItemCardState();
}

class _WLegalDepartmentItemCardState extends State<WLegalDepartmentItemCard> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(covariant final WLegalDepartmentItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.department != widget.department || oldWidget.index != widget.index) {
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
          child: LegalDepartmentMainPage(
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
                    user: UserReadDto(id: '', avatarUrl: widget.department.avatarUrl, fullName: widget.department.title),
                    size: 50,
                  ),
                  Flexible(
                    child: Text(widget.department.title ?? '', maxLines: 1).bodyMedium(overflow: TextOverflow.ellipsis).bold(),
                  ),
                ],
              ).expanded(),
              if (widget.ctrl.haveAdminAccess)
                SizeTransition(
                  sizeFactor: Tween<double>(begin: 1.0, end: 0.0).animate(_animation),
                  axis: Axis.horizontal,
                  child:
                      Container(
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
                          onTap: () => widget.ctrl.navigateToEditDepartmentPage(widget.department),
                        ),
                        // WPopupMenuItem(
                        //   title: s.delete,
                        //   icon: AppIcons.delete,
                        //   titleColor: AppColors.red,
                        //   iconColor: AppColors.red,
                        //   onTap: () => widget.ctrl.deleteDepartment(widget.department),
                        // ),
                      ]),
                ),
            ],
          ),
          WLabelProgressBar(
            value: widget.department.signed == 0 ? 0 : ((widget.department.signed * 100) / widget.department.total).floor(),
            progressColor: AppColors.green,
            minTextWidth: 60,
          ),
          _item(title: s.legalCase, value: Text(widget.department.casesCount.toString().separateNumbers3By3()).bodyMedium()),
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _item(title: s.contract, value: Text(widget.department.total.toString().separateNumbers3By3()).bodyMedium()),
              _item(title: s.pending, value: Text(widget.department.pending.toString().separateNumbers3By3())),
              _item(title: s.signed, value: Text(widget.department.signed.toString().separateNumbers3By3())),
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
                            subtitle: WLabelProgressBar(
                              title: member.type.isOwner()
                                  ? PermissionType.manager.getTitle()
                                  : member.permissions.getByName(PermissionName.legal)?.permissionType?.getTitle() ?? '',
                              value: member.progressPercentage ?? 0,
                              height: 5,
                            ).marginOnly(top: 5),
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
    required final Widget value,
    final CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) => Row(
    crossAxisAlignment: crossAxisAlignment,
    mainAxisSize: MainAxisSize.min,
    spacing: 5,
    children: [
      Text("$title:").bodyMedium(color: context.theme.hintColor),
      value,
    ],
  );
}
