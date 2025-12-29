import 'package:bermooda_business/core/core.dart';
import 'package:bermooda_business/core/widgets/widgets.dart';
import 'package:bermooda_business/view/modules/subtask/subtask_card/subtask_card.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:u/utilities.dart';

import '../../../../data/data.dart';
import 'subtask_list_controller.dart';

class SubtaskListPage extends StatefulWidget {
  const SubtaskListPage({
    required this.dataSourceType,
    required this.mainSourceId,
    required this.sourceId,
    required this.scrollToSubtaskId,
    this.canEdit = true,
    super.key,
  });

  final SubtaskDataSourceType dataSourceType;
  final String mainSourceId;
  final int sourceId;
  final String? scrollToSubtaskId;
  final bool canEdit;

  @override
  State<SubtaskListPage> createState() => _SubtaskListPageState();
}

class _SubtaskListPageState extends State<SubtaskListPage> {
  late final SubtaskListController ctrl;

  @override
  void initState() {
    ctrl = Get.put(
      SubtaskListController(
        dataSourceType: widget.dataSourceType,
        mainSourceId: widget.mainSourceId,
        sourceId: widget.sourceId,
        scrollToSubtaskId: widget.scrollToSubtaskId,
        canEdit: widget.canEdit,
      ),
    );
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return UScaffold(
      floatingActionButtonLocation: isPersianLang
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: ctrl.haveAdminAccess
          ? FloatingActionButton(
              heroTag: "createSubtaskFAB",
              tooltip: s.newTask,
              onPressed: ctrl.createSubtask,
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
            )
          : null,
      body: Stack(
        children: [
          Obx(
            () {
              if (ctrl.pageState.isLoaded() && ctrl.subtasks.isEmpty) {
                return const Center(child: WEmptyWidget());
              }
              return const SizedBox.shrink();
            },
          ),
          Obx(
            () {
              if (ctrl.pageState.isLoading() || ctrl.pageState.isInitial()) {
                return _loadingShimmerList();
              }

              if (ctrl.pageState.isError()) {
                return Center(child: WErrorWidget(onTapButton: ctrl.onTryAgain));
              }

              return WSmartRefresher(
                controller: ctrl.refreshController,
                onRefresh: ctrl.onRefresh,
                enablePullUp: false,
                child: ListView.builder(
                  itemCount: ctrl.subtasks.length,
                  controller: ctrl.scrollController,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 100),
                  itemBuilder: (final context, final index) {
                    final subtask = ctrl.subtasks[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: AutoScrollTag(
                        key: ValueKey(ctrl.subtasks[index].id),
                        controller: ctrl.scrollController,
                        index: index,
                        highlightColor: context.theme.primaryColor.withValues(alpha: 0.5),
                        child: WSubtaskCard(
                          subtask: subtask,
                          onChangedCheckBoxStatus: (final model) => ctrl.deleteSubtask(model),
                          onEdited: ctrl.addOrUpdateSubtask,
                          onDelete: () => ctrl.deleteSubtask(subtask),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _loadingShimmerList() => ListView.builder(
    itemCount: 10,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (final context, final index) => WCard(
      child: SizedBox(width: context.width, height: 70),
    ),
  ).shimmer();
}
