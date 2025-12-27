import 'package:u/utilities.dart';

import '../../widgets.dart';
import '../kanban_board.dart';

class SectionView<S, T> extends StatelessWidget {
  const SectionView({
    required this.sectionIndex,
    required this.ctrl,
    super.key,
  });

  final int sectionIndex;
  final KanbanController<S, T> ctrl;

  @override
  Widget build(final BuildContext context) {
    final scrollController = ctrl.sectionScrollControllers[sectionIndex];
    final pageState = context.findAncestorStateOfType<WKanbanBoardState<S, T>>()!;

    return Obx(() {
      final Section<S, T> section = ctrl.sections[sectionIndex];

      return Visibility(
        key: ctrl.sectionKeys[sectionIndex],
        visible: section.isVisible,
        child: Container(
          decoration: BoxDecoration(
            color: pageState.widget.backgroundColor ?? context.theme.scaffoldBackgroundColor,
          ),
          child: Column(
            children: [
              /// Header
              if (section.isAddSectionPage) pageState.widget.headerOfAddNewSectionPage ?? const SizedBox() else pageState.widget.sectionHeaderBuilder(section),

              /// Body
              if (section.isAddSectionPage)
                Expanded(child: pageState.widget.addNewSectionPageBody ?? const SizedBox())
              else
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (section.children.isEmpty) const WEmptyWidget(),
                      ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        itemCount: section.children.length + 1,
                        itemBuilder: (final context, final itemIndex) {
                          if (itemIndex == section.children.length) {
                            return _buildDropTarget(context, sectionIndex, itemIndex, ctrl: ctrl, child: const SizedBox(height: 100));
                          }
                          final item = section.children[itemIndex];
                          return _buildDropTarget(context, sectionIndex, itemIndex,
                              ctrl: ctrl,
                              child: ItemCard<S, T>(
                                item: item,
                                sectionIdx: sectionIndex,
                                ctrl: ctrl,
                              ));
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDropTarget(
    final BuildContext context,
    final int sectionIdx,
    final int itemIdx, {
    required final Widget child,
    required final KanbanController<S, T> ctrl,
  }) {
    final draggingItem = ctrl.draggedItem;

    return DragTarget<Item<T>>(
      builder: (final context, final candidateData, final rejectedData) {
        final isHovering = candidateData.isNotEmpty && ctrl.enableDrag.value;
        return Column(
          children: [
            if (isHovering && draggingItem != null)
              Opacity(
                  opacity: 0.3,
                  child: ItemCard<S, T>(
                    item: draggingItem,
                    sectionIdx: sectionIdx,
                    ctrl: ctrl,
                  )),
            child,
          ],
        );
      },
      onWillAcceptWithDetails: (final details) {
        if (!ctrl.enableDrag.value) {
          return false;
        }
        if (details.data.id == (child is ItemCard ? child.item.id : null)) {
          return false;
        }
        return true;
      },
      onAcceptWithDetails: (final details) {
        if (!ctrl.enableDrag.value) return;
        // ctrl.moveItem(details.data, sectionIdx, itemIdx);
        ctrl.onItemMoved(details.data, ctrl.sourceSec, ctrl.sourcePos, sectionIdx, itemIdx, ctrl.sections[sectionIdx]);
        ctrl.endAndClearDrag();
      },
    );
  }
}

class ItemCard<S, T> extends StatelessWidget {
  final Item<T> item;
  final int sectionIdx;
  final KanbanController<S, T> ctrl;

  const ItemCard({
    required this.item,
    required this.sectionIdx,
    required this.ctrl,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final pageState = context.findAncestorStateOfType<WKanbanBoardState<S, T>>()!;

    final Widget childWidget = pageState.widget.itemBuilder(ctrl.sections[sectionIdx], item, ctrl.sectionScrollControllers[sectionIdx]);

    return Obx(
      () {
        if (ctrl.enableDrag.value) {
          return LongPressDraggable<Item<T>>(
            data: item,
            feedback: _buildGhostItem(context, pageState),
            childWhenDragging: Visibility(
              visible: false,
              maintainAnimation: true,
              maintainState: true,
              child: childWidget,
            ),
            onDragStarted: () {
              int sectionIdx = ctrl.sections.indexWhere((final s) => s.children.any((final t) => t.id == item.id));
              int itemIdx = ctrl.sections[sectionIdx].children.indexWhere((final t) => t.id == item.id);
              ctrl.startDrag(item, sectionIdx, itemIdx);
              ctrl.startAutoScroll(pageState.context);
            },
            onDragEnd: (final details) {
              ctrl.endAndClearDrag();
            },
            onDraggableCanceled: (final velocity, final offset) {
              ctrl.endAndClearDrag();
            },
            child: childWidget,
          );
        } else {
          return childWidget;
        }
      },
    );
  }

  Widget _buildGhostItem(final BuildContext ctx, final WKanbanBoardState<S, T> pageState) {
    return AnimatedRotation(
      turns: -0.01,
      duration: 50.milliseconds,
      child: Opacity(
        opacity: 0.2,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: ctx.width * 0.8),
          child: pageState.widget.ghostBuilder?.call(item) ?? pageState.widget.itemBuilder(ctrl.sections[sectionIdx], item, ctrl.sectionScrollControllers[sectionIdx]),
        ),
      ),
    );
  }
}
