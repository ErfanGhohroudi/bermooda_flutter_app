import 'package:bermooda_business/core/core.dart';
import 'package:bermooda_business/core/widgets/widgets.dart';
import 'package:bermooda_business/core/widgets/subtask_card/subtask_card.dart';
import 'package:u/utilities.dart';

import 'legal_case_subtask_list_controller.dart';

class LegalCaseSubtaskListPage extends StatefulWidget {
  const LegalCaseSubtaskListPage({
    required this.legalDepartmentId,
    required this.legalCaseId,
    required this.canEdit,
    super.key,
  });

  final int legalDepartmentId;
  final int legalCaseId;
  final bool canEdit;

  @override
  State<LegalCaseSubtaskListPage> createState() => _LegalCaseSubtaskListPageState();
}

class _LegalCaseSubtaskListPageState extends State<LegalCaseSubtaskListPage> {
  late final LegalCaseSubtaskListController ctrl;

  @override
  void initState() {
    ctrl = Get.put(
      LegalCaseSubtaskListController(
        legalDepartmentId: widget.legalDepartmentId,
        caseId: widget.legalCaseId,
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
              heroTag: "createLegalSubtaskFAB",
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
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 100),
                  itemBuilder: (final context, final index) {
                    final subtask = ctrl.subtasks[index];
                    return WSubtaskCard(
                      subtask: subtask,
                      onChangedCheckBoxStatus: (final model) => ctrl.deleteSubtask(model),
                      onEdited: ctrl.addOrUpdateSubtask,
                      onDelete: () => ctrl.deleteSubtask(subtask),
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
