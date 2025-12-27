import 'package:u/utilities.dart';

import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/extensions/money_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';
import '../create_update/project_create_update_page.dart';
import '../../project_main_page.dart';

class ProjectItemCard extends StatefulWidget {
  const ProjectItemCard({
    required this.project,
    required this.index,
    required this.isReorderEnabled,
    required this.showMoreIcon,
    required this.onDelete,
    required this.onEdited,
    super.key,
  });

  final ProjectReadDto project;
  final int index;
  final bool isReorderEnabled;
  final bool showMoreIcon;
  final VoidCallback onDelete;
  final Function(ProjectReadDto project) onEdited;

  @override
  State<ProjectItemCard> createState() => _ProjectItemCardState();
}

class _ProjectItemCardState extends State<ProjectItemCard> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(covariant final ProjectItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.project != widget.project || oldWidget.showMoreIcon != widget.showMoreIcon || oldWidget.index != widget.index) {
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
          child: ProjectMainPage(
            project: widget.project,
            onEdited: widget.onEdited,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Row(
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
                    user: UserReadDto(id: '', avatarUrl: widget.project.avatar?.url, fullName: widget.project.title),
                    size: 50,
                  ),
                  Flexible(
                    child: Text(widget.project.title ?? '', maxLines: 1).bodyMedium(overflow: TextOverflow.ellipsis).bold(),
                  ),
                ],
              ).expanded(),
              if (widget.showMoreIcon)
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
                          onTap: () {
                            bottomSheet(
                              title: s.editProject,
                              child: ProjectCreateUpdatePage(
                                project: widget.project,
                                onResponse: widget.onEdited,
                              ),
                            );
                          },
                        ),
                        // WPopupMenuItem(
                        //   title: s.delete,
                        //   icon: AppIcons.delete,
                        //   titleColor: AppColors.red,
                        //   iconColor: AppColors.red,
                        //   onTap: widget.onDelete,
                        // ),
                      ]),
                ),
            ],
          ),
          WLabelProgressBar(
            // title: s.progressStatus,
            value: widget.project.progress,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              _item(
                title: s.budget,
                value: Text(
                  (widget.project.budget ?? '0') != '0' ? (widget.project.budget ?? '0').toString().toTomanMoney() : '- -',
                ).bodyMedium(),
              ),
              _item(title: s.startDate, value: Text(widget.project.startDate ?? '- -')),
              _item(title: s.dueDate, value: Text(widget.project.dueDate ?? '- -')),
            ],
          ),
          if (!widget.project.members.isNullOrEmpty()) ...[
            const Divider(height: 0),
            InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                bottomSheet(
                  title: s.members,
                  child: Column(
                    children: List.generate(
                      widget.project.members?.length ?? 0,
                      (final index) => WCard(
                        showBorder: true,
                        child: ListTile(
                          minTileHeight: 20,
                          minVerticalPadding: 0,
                          contentPadding: EdgeInsets.zero,
                          leading: WCircleAvatar(user: widget.project.members![index], size: 40),
                          title: Text(widget.project.members![index].fullName ?? '- -').bodyMedium(),
                          subtitle: WLabelProgressBar(
                            title: widget.project.members![index].type.isOwner()
                                ? PermissionType.manager.getTitle()
                                : widget.project.members![index].permissionType?.getTitle() ?? '',
                            value: widget.project.members![index].progressPercentage ?? 0,
                            height: 5,
                          ).marginOnly(top: 5),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WOverlappingAvatarRow(
                    users: widget.project.members!,
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
    spacing: 10,
    children: [
      Text("$title : ").bodyMedium(color: context.theme.hintColor),
      value.expanded(),
    ],
  );
}
