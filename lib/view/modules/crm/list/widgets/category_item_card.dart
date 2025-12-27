import 'package:u/utilities.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';
import '../../crm_category_main_page.dart';
import '../category_create_update/crm_category_create_update_page.dart';

class CategoryItemCard extends StatefulWidget {
  const CategoryItemCard({
    required this.category,
    required this.index,
    required this.isReorderEnabled,
    required this.showMoreIcon,
    required this.onDelete,
    required this.onEdited,
    super.key,
  });

  final CrmCategoryReadDto category;
  final int index;
  final bool isReorderEnabled;
  final bool showMoreIcon;
  final VoidCallback onDelete;
  final Function(CrmCategoryReadDto group) onEdited;

  @override
  State<CategoryItemCard> createState() => _CategoryItemCardState();
}

class _CategoryItemCardState extends State<CategoryItemCard> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(covariant final CategoryItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category || oldWidget.showMoreIcon != widget.showMoreIcon || oldWidget.index != widget.index) {
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
          child: CrmCategoryMainPage(
            category: widget.category,
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
                    user: UserReadDto(id: '', avatarUrl: widget.category.avatar?.url, fullName: widget.category.title),
                    size: 50,
                  ),
                  Flexible(child: Text(widget.category.title ?? '', maxLines: 1).bodyMedium(overflow: TextOverflow.ellipsis).bold()),
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
                          title: s.editCategory,
                          child: CrmCategoryCreateUpdatePage(
                            category: widget.category,
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
          WLabelProgressBar(value: widget.category.progress),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisSize: MainAxisSize.min,
          //   spacing: 5,
          //   children: [
          //     WLabelProgressBar(
          //       title: s.customers,
          //       value: widget.category.summeryCustomers?.customersCount ?? 0,
          //       progressColor: AppColors.green,
          //       minTextWidth: 60,
          //     ),
          //     WLabelProgressBar(
          //       title: s.followUp,
          //       value: widget.category.summeryCustomers?.customersIsFollowedCount ?? 0,
          //       progressColor: AppColors.orange,
          //       minTextWidth: 60,
          //     ),
          //     WLabelProgressBar(
          //       title: s.sales,
          //       value: widget.category.summeryCustomers?.customersIsNotFollowedCount ?? 0,
          //       progressColor: AppColors.red,
          //       minTextWidth: 60,
          //     ),
          //   ],
          // ),
          /////////////////////////////////
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisSize: MainAxisSize.min,
          //   spacing: 6,
          //   children: [
          //     _item(
          //       title: s.budget,
          //       value: Text(
          //         (widget.category.budget ?? '0') != '0'
          //             ? ("${widget.category.budget.separateNumbers3By3()}"
          //             "${widget.category.currency?.currencyName == null ? '' : " ${widget.category.currency?.currencyName}"
          //             "${widget.category.currency?.country == null ? '' : "(${widget.category.currency?.country})"}"}")
          //             : '- -',
          //       ).bodyMedium(),
          //     ),
          //     _item(title: s.startDate, value: Text(widget.category.startDate ?? '- -')),
          //     _item(title: s.dueDate, value: Text(widget.category.dueDate ?? '- -')),
          //   ],
          // ),
          if (!widget.category.members.isNullOrEmpty()) ...[
            const Divider(height: 0),
            InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                bottomSheet(
                  title: s.members,
                  child: Column(
                    children: List.generate(
                      widget.category.members?.length ?? 0,
                      (final index) => WCard(
                        showBorder: true,
                        child: ListTile(
                          minTileHeight: 20,
                          minVerticalPadding: 0,
                          contentPadding: EdgeInsets.zero,
                          leading: WCircleAvatar(user: widget.category.members![index], size: 40),
                          title: Text(widget.category.members![index].fullName ?? '- -').bodyMedium(),
                          subtitle: WLabelProgressBar(
                            title: widget.category.members![index].type.isOwner()
                                ? PermissionType.manager.getTitle()
                                : widget.category.members![index].permissionType?.getTitle() ?? '',
                            value: widget.category.members![index].progressPercentage ?? 0,
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
                    users: widget.category.members!,
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

  // Widget _item({
  //   required final String title,
  //   required final Widget value,
  //   final CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  // }) =>
  //     Row(
  //       crossAxisAlignment: crossAxisAlignment,
  //       mainAxisSize: MainAxisSize.min,
  //       spacing: 10,
  //       children: [
  //         Text("$title : ").bodyMedium(color: context.theme.hintColor),
  //         value.expanded(),
  //       ],
  //     );
}
