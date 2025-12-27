import 'package:u/utilities.dart';

import '../widgets.dart';
import '../../core.dart';
import 'kanban_board_controller.dart';
import 'section/section_page.dart';
import 'view_models/section_view_model.dart';
import 'view_models/item_view_model.dart';

export 'view_models/section_view_model.dart';
export 'view_models/item_view_model.dart';
export 'kanban_board_controller.dart';

/// [S] is the [Section] type. example: [WKanbanBoard<String>()]
/// [T] is the [Item] type. example: [WKanbanBoard<String>()]
class WKanbanBoard<S , T> extends StatefulWidget {
  const WKanbanBoard({
    required this.controller,
    required this.itemBuilder,
    required this.sectionHeaderBuilder,
    this.ghostBuilder,
    this.addNewSectionPageBody,
    this.headerOfAddNewSectionPage,
    this.backgroundColor,
    super.key,
  });

  final KanbanController<S, T> controller;
  final Widget Function(Section<S , T>, Item<T>, ScrollController scrollController) itemBuilder;
  final Widget Function(Item<T>)? ghostBuilder;
  final Widget Function(Section<S , T>) sectionHeaderBuilder;
  final Widget? addNewSectionPageBody;
  final Widget? headerOfAddNewSectionPage;
  final Color? backgroundColor;

  @override
  State<WKanbanBoard<S, T>> createState() => WKanbanBoardState<S, T>();
}

class WKanbanBoardState<S, T> extends State<WKanbanBoard<S, T>> {
  late final KanbanController<S, T> ctrl = widget.controller;

  @override
  Widget build(final BuildContext context) {
    return Listener(
      onPointerMove: (final event) {
        if (ctrl.isDragging.value) {
          ctrl.onDragUpdate(event.position);
        }
      },
      child: Obx(
        () => PageView.builder(
          clipBehavior: Clip.none,
          controller: ctrl.pageController,
          itemCount: ctrl.sections.length,
          itemBuilder: (final ctx, final sectionIndex) {
            return LazyKeepAliveTabView(
              builder: () => Obx(() {
                return Stack(
                  fit: StackFit.passthrough,
                  children: [
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: ctrl.isDragging.value ? 20.0 : 0.0,
                        vertical: ctrl.isDragging.value ? 24.0 : 0.0,
                      ),
                      child: SectionView<S, T>(sectionIndex: sectionIndex, ctrl: widget.controller),
                    ),

                    /// Forward Icon
                    if (ctrl.isDragging.value && !isPersianLang && sectionIndex < ctrl.sections.length - 1 && ctrl.sections[sectionIndex + 1].isVisible)
                      Icon(Icons.arrow_forward_ios_rounded, size: 30, color: Colors.grey.shade400).alignAtCenterRight(),
                    if (ctrl.isDragging.value && isPersianLang && sectionIndex < ctrl.sections.length - 1 && ctrl.sections[sectionIndex + 1].isVisible)
                      Icon(Icons.arrow_forward_ios_rounded, size: 30, color: Colors.grey.shade400).alignAtCenterLeft(),

                    /// Backward Icon
                    if (ctrl.isDragging.value && isPersianLang && sectionIndex > 0)
                      Icon(Icons.arrow_back_ios_rounded, size: 30, color: Colors.grey.shade400).alignAtCenterRight(),
                    if (ctrl.isDragging.value && !isPersianLang && sectionIndex > 0)
                      Icon(Icons.arrow_back_ios_rounded, size: 30, color: Colors.grey.shade400).alignAtCenterLeft(),
                  ],
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
