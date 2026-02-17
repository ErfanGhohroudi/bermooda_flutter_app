import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../domain/entities/warehouse.dart';
import '../pages/warehouse_create_update_page.dart';

class WarehouseCard extends StatefulWidget {
  const WarehouseCard({
    required this.warehouse,
    required this.index,
    required this.isReorderEnabled,
    required this.showMoreIcon,
    required this.onDelete,
    required this.onEdited,
    super.key,
  });

  final Warehouse warehouse;
  final int index;
  final bool isReorderEnabled;
  final bool showMoreIcon;
  final VoidCallback onDelete;
  final Function(Warehouse warehouse) onEdited;

  @override
  State<WarehouseCard> createState() => _WarehouseCardState();
}

class _WarehouseCardState extends State<WarehouseCard> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(covariant final WarehouseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.warehouse != widget.warehouse || oldWidget.showMoreIcon != widget.showMoreIcon || oldWidget.index != widget.index) {
      setState(() {});
    }
    if (widget.isReorderEnabled != oldWidget.isReorderEnabled) {
      if (widget.isReorderEnabled) {
        _animationController.forward();
      } else {
        _animationController.reverse();
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
        if (widget.isReorderEnabled) return AppSnackBar.snackbarRed(title: s.warning, subtitle: s.saveYourChangesFirst);
        // Can navigate to warehouse details if needed
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
                    user: UserReadDto(
                      id: '',
                      avatarUrl: widget.warehouse.avatarUrl,
                      fullName: widget.warehouse.title ?? '',
                    ),
                    size: 50,
                  ),
                  Flexible(
                    child: Text(
                      widget.warehouse.title ?? '',
                      maxLines: 1,
                    )
                        .bodyMedium(overflow: TextOverflow.ellipsis)
                        .bold(),
                  ),
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
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: context.theme.hintColor,
                    ),
                  ).showMenus([
                    WPopupMenuItem(
                      title: s.edit,
                      icon: AppIcons.editOutline,
                      titleColor: AppColors.green,
                      iconColor: AppColors.green,
                      onTap: () {
                        bottomSheet(
                          title: s.editWarehouse,
                          child: WarehouseCreateUpdatePage(
                            warehouse: widget.warehouse,
                            onResponse: widget.onEdited,
                          ),
                        );
                      },
                    ),
                    WPopupMenuItem(
                      title: s.delete,
                      icon: AppIcons.delete,
                      titleColor: AppColors.red,
                      iconColor: AppColors.red,
                      onTap: widget.onDelete,
                    ),
                  ]),
                ),
            ],
          ),
          if (widget.warehouse.code != null && widget.warehouse.code!.isNotEmpty)
            Row(
              children: [
                Text('${s.warehouseCode}: ').bodyMedium(color: context.theme.hintColor),
                Text(widget.warehouse.code!).bodyMedium(),
              ],
            ),
          if (widget.warehouse.capacity != null)
            Row(
              children: [
                Text('${s.capacity}: ').bodyMedium(color: context.theme.hintColor),
                Text(widget.warehouse.capacity!.toString()).bodyMedium(),
              ],
            ),
          if (widget.warehouse.stateName != null || widget.warehouse.cityName != null)
            Row(
              children: [
                Text('${s.location}: ').bodyMedium(color: context.theme.hintColor),
                Text(
                  [
                    widget.warehouse.cityName,
                    widget.warehouse.stateName,
                  ].whereType<String>().join(', '),
                ).bodyMedium(),
              ],
            ),
        ],
      ),
    );
  }
}
