import 'package:u/utilities.dart';

import '../../../core/core.dart';
import 'view_models/item_view_model.dart';
import '../../../core/widgets/kanban_board/view_models/section_view_model.dart';

/// Controller for the Kanban board, managing sections and drag state.
class KanbanController<S, T> {
  KanbanController({
    required final PageController externalPageController,
    required this.onItemMoved,
    final bool enableDrag = true,
  }) {
    pageController = externalPageController;
    this.enableDrag(enableDrag);
  }

  late final PageController pageController;

  /// Enable Dragging Items
  /// default value is [true]
  final RxBool enableDrag = true.obs;

  final RxList<Section<S, T>> sections = <Section<S, T>>[].obs;
  final Rx<bool> isDragging = false.obs;

  final List<ScrollController> sectionScrollControllers = [];
  final List<GlobalKey> sectionKeys = [];

  /// will call when an item dragged and dropped successful.
  final void Function(Item<T> item, int fromSection, int fromIndex, int toSection, int toIndex, Section<S, T> targetSection) onItemMoved;

  Item<T>? draggedItem;
  int sourceSec = -1, sourcePos = -1;
  Offset? lastDragPos;
  Timer? horizTimer, vertTimer;

  // void setupScrollControllersAndKeys() {
  //   for (final controller in sectionScrollControllers) {
  //     controller.dispose();
  //   }
  //   sectionScrollControllers.clear();
  //   sectionKeys.clear();
  //
  //   if (sections.isNotEmpty) {
  //     sectionScrollControllers.addAll(List.generate(sections.length, (final _) => ScrollController()));
  //     sectionKeys.addAll(List.generate(sections.length, (final _) => GlobalKey()));
  //   }
  // }

  void onClose() {
    for (final c in sectionScrollControllers) {
      c.dispose();
    }
    sections.close();
    isDragging.close();
    pageController.dispose();
    horizTimer?.cancel();
    vertTimer?.cancel();
    debugPrint("KanbanController 'onClose' called");
  }

  /// Set [enableDrag] value and restate widget
  void setDragEnabled(final bool value) {
    enableDrag(value);
  }

  /// Add [Section] at [index]
  void addSectionAt(final int index, final Section<S, T> section) {
    if (sections.subject.isClosed) return;
    if (index < 0) return;
    if (index > sections.length) {
      debugPrint("Error: Index out of bounds for adding a section.");
      return;
    }
    sections.insert(index, section);
    sectionScrollControllers.insert(index, ScrollController());
    sectionKeys.insert(index, GlobalKey());
  }

  /// Insert [Section] at end of [sections] list.
  void addSection(final Section<S, T> section) {
    if (sections.subject.isClosed) return;
    final sectionIdx = sections.last.isAddSectionPage ? sections.length - 1 : sections.length;
    sections.insert(sectionIdx, section);
    sectionScrollControllers.insert(sectionIdx, ScrollController());
    sectionKeys.insert(sectionIdx, GlobalKey());
  }

  /// Update old [Section] with new [Section] data.
  void updateSection(final Section<S, T> section) {
    if (sections.subject.isClosed) return;
    final existSectionIdx = sections.indexWhere((final s) => s.slug == section.slug);
    if (existSectionIdx != -1) {
      sections[existSectionIdx].data = section.data;
      sections.refresh();
    }
  }

  /// Remove [Section] at [index]
  void removeSectionAt(final int index) {
    if (sections.subject.isClosed) return;
    if (index < 0 || index >= sections.length) {
      debugPrint("Error: Index out of bounds for removing a section.");
      return;
    }
    // بسیار مهم: کنترلر اسکرول باید dispose شود تا از نشت حافظه جلوگیری شود
    sectionScrollControllers[index].dispose();

    sections.removeAt(index);
    sectionScrollControllers.removeAt(index);
    sectionKeys.removeAt(index);
  }

  /// Remove [Section] from [sections] list.
  void removeSection(final String sectionSlug) {
    if (sections.subject.isClosed) return;
    final index = sections.indexWhere((final e) => e.slug == sectionSlug);

    if (index == -1) {
      debugPrint("Error: Index out of bounds for removing a section.");
      return;
    }
    if (sections.subject.isClosed) return;
    // بسیار مهم: کنترلر اسکرول باید dispose شود تا از نشت حافظه جلوگیری شود
    sectionScrollControllers[index].dispose();

    sections.removeAt(index);
    sectionScrollControllers.removeAt(index);
    sectionKeys.removeAt(index);
  }

  /// Add new [Item] in target [Section]'s [index]
  void addItem(final int sectionIndex, final int itemIndex, final Item<T> item) {
    if (sections.subject.isClosed) return;
    if (sectionIndex < 0 || sectionIndex >= sections.length) {
      debugPrint("Error: Section index out of bounds for adding an item.");
      return;
    }
    final section = sections[sectionIndex];
    if (itemIndex < 0 || itemIndex > section.children.length) {
      debugPrint("Error: Item index out of bounds for adding an item.");
      return;
    }
    section.children.insert(itemIndex, item);
  }

  /// Remove [Item] from target [Section]'s [index]
  Item<T>? removeItem(final int sectionIndex, final int itemIndex) {
    if (sections.subject.isClosed) return null;
    if (sectionIndex < 0 || sectionIndex >= sections.length) {
      debugPrint("Error: Section index out of bounds for removing an item.");
      return null;
    }
    final section = sections[sectionIndex];
    if (itemIndex < 0 || itemIndex >= section.children.length) {
      debugPrint("Error: Item index out of bounds for removing an item.");
      return null;
    }
    return section.children.removeAt(itemIndex);
  }

  /// Fill [sections] list with [newSections]
  void updateBoardFromSocket(final List<Section<S, T>> newSections) {
    if (sections.subject.isClosed) return;
    for (final controller in sectionScrollControllers) {
      controller.dispose();
    }
    sectionScrollControllers.clear();
    sectionKeys.clear();

    sections.assignAll(newSections);

    // ۳. منابع جدید را برای بخش‌های جدید بساز
    sectionScrollControllers.assignAll(List.generate(sections.length, (final _) => ScrollController()));
    sectionKeys.assignAll(List.generate(sections.length, (final _) => GlobalKey()));
  }

  /// Update an old [Item] with [itemData]
  /// if [Item] order out of bounds for insert an item; [Item] will insert at end of list
  void upsertItemFromSocket({
    required final String sectionId,
    required final Item<T> itemData,
    required final int itemInsertIndex,
  }) {
    if (sections.subject.isClosed) return;
    // آیتم اگر وجود داشت حذف شود
    for (final section in sections) {
      section.children.removeWhere((final item) => item.id == itemData.id);
    }

    if (sections.subject.isClosed) return;
    final targetSectionIndex = sections.indexWhere((final s) => s.slug == sectionId);
    if (targetSectionIndex == -1) {
      debugPrint("Socket Error: Section with ID '$sectionId' not found.");
      return;
    }
    if (sections.subject.isClosed) return;
    final targetSection = sections[targetSectionIndex];

    try {
      targetSection.children.insert(itemInsertIndex, itemData);
      debugPrint("Item '${itemData.id}' inserted into section '$sectionId'  at '$itemInsertIndex' index of list.");
    } catch (e) {
      debugPrint("Error: Item order out of bounds for insert an item with itemInsertIndex: '$itemInsertIndex'.");
      targetSection.children.add(itemData);
      debugPrint("Item '${itemData.id}' inserted into section '$sectionId' at end of list.");
    }
  }

  /// Update an old [Item] with [itemData]
  /// or insert [itemData]
  /// if [Item] order out of bounds for insert an item; [Item] will insert at end of list
  void upsertItem({
    required final int sectionIndex,
    required final Item<T> itemData,
    required final int itemIndex,
  }) {
    if (sections.subject.isClosed) return;
    final targetSection = sections[sectionIndex];

    try {
      if (targetSection.children[itemIndex].slug == itemData.slug) {
        targetSection.children[itemIndex] = itemData;
        debugPrint("Item '${itemData.id}' updated in section '$sectionIndex'  at '$itemIndex' index of list.");
      } else {
        targetSection.children.insert(itemIndex, itemData);
        debugPrint("Item '${itemData.id}' inserted into section '$sectionIndex'  at '$itemIndex' index of list.");
      }
    } catch (e) {
      debugPrint("Error: Item order out of bounds for insert an item with itemInsertIndex: '$itemIndex'.");
      targetSection.children.add(itemData);
      debugPrint("Item '${itemData.id}' inserted into section '$sectionIndex' at end of list.");
    }
  }

  ///
  void startDrag(final Item<T> item, final int sectionIndex, final int itemIndex) {
    isDragging.value = true;
    draggedItem = item;
    sourceSec = sectionIndex;
    sourcePos = itemIndex;

    if (sections.last.isAddSectionPage) sections.last.isVisible = false;
  }

  void endAndClearDrag() {
    horizTimer?.cancel();
    vertTimer?.cancel();
    isDragging.value = false;
    draggedItem = null;
    sourceSec = sourcePos = -1;
    lastDragPos = null;
    if (sections.last.isAddSectionPage) sections.last.isVisible = true;
  }

  void moveItem(final Item<T> item, final int targetSec, int targetPos) {
    if (sourceSec == targetSec && sourcePos < targetPos) targetPos--;
    final moved = sections[sourceSec].children.removeAt(sourcePos);
    sections[targetSec].children.insert(targetPos, moved);
    endAndClearDrag();
    onItemMoved(moved, sourceSec, sourcePos, targetSec, targetPos, sections[targetSec]);
  }

  void onDragUpdate(final Offset globalPos) {
    lastDragPos = globalPos;
    _vertScroll(globalPos);
  }

  void startAutoScroll(final BuildContext ctx) {
    horizTimer?.cancel();
    vertTimer?.cancel();
    horizTimer = Timer.periodic(const Duration(milliseconds: 1000), (final timer) {
      if (lastDragPos != null) _horizScroll(ctx, lastDragPos!);
    });
    vertTimer = Timer.periodic(const Duration(milliseconds: 100), (final _) {
      if (lastDragPos != null) _vertScroll(lastDragPos!);
    });
  }

  void _horizScroll(final BuildContext ctx, final Offset pos) {
    final screenWidth = ctx.size?.width ?? 0;
    final currentPage = pageController.page?.round() ?? 0;

    final bool isRight = pos.dx > screenWidth * 0.9;
    final bool isLeft = pos.dx < screenWidth * 0.1;

    if ((isPersianLang ? isLeft : isRight) && currentPage < sections.length - 1 && sections[currentPage + 1].isVisible) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else if ((isPersianLang ? isRight : isLeft) && currentPage > 0) {
      pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _vertScroll(final Offset globalPos) {
    final secIndex = _findSectionIndex(globalPos);
    if (secIndex == null || secIndex >= sectionScrollControllers.length) return;

    final sc = sectionScrollControllers[secIndex];
    final ctx = sectionKeys[secIndex].currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final local = box.globalToLocal(globalPos);

    const double edgeMargin = 50.0, speed = 20.0;

    // محاسبه ارتفاع هدر — چون اولین child Container در Column هست
    final headerHeight = _getHeaderHeight(ctx);
    final dyFromHeader = local.dy - headerHeight;

    // اگر هنوز در محدوده‌ی هدر هستیم، اسکرول نکن
    if (dyFromHeader < 0) return;

    if (dyFromHeader < edgeMargin && sc.offset > 0) {
      sc.animateTo(sc.offset - speed, duration: const Duration(milliseconds: 50), curve: Curves.linear);
    } else if (local.dy > box.size.height - edgeMargin && sc.offset < sc.position.maxScrollExtent) {
      sc.animateTo(sc.offset + speed, duration: const Duration(milliseconds: 50), curve: Curves.linear);
    }
  }

  int? _findSectionIndex(final Offset pos) {
    for (int i = 0; i < sectionKeys.length; i++) {
      final ctx = sectionKeys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox;
      final rect = box.localToGlobal(Offset.zero) & box.size;
      if (rect.contains(pos)) return i;
    }
    return null;
  }

  double _getHeaderHeight(final BuildContext? ctx) {
    try {
      if (ctx == null) return 56.0;

      final element = ctx as Element;

      RenderBox? headerBox;
      element.visitChildElements((final child) {
        final widget = child.widget;
        if (widget is Column) {
          child.visitChildElements((final subChild) {
            final subWidget = subChild.widget;
            if (subWidget is Container) {
              final subRenderBox = subChild.renderObject;
              if (subRenderBox is RenderBox) {
                headerBox = subRenderBox;
              }
            }
          });
        }
      });

      if (headerBox != null) {
        return headerBox!.size.height;
      }
    } catch (_) {
      // Ignore errors silently and fall back to default
    }

    return 56.0; // fallback
  }
}
