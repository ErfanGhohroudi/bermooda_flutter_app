import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../../project/task/create_update/create_update_subtask/create_update_subtask_page.dart';
import '../../../reports/controllers/legal/legal_case_reports_controller.dart';

class LegalCaseSubtaskListController extends GetxController {
  late final int _legalDepartmentId;
  late final int _caseId;
  late final bool canEdit;

  LegalCaseSubtaskListController({
    required final int legalDepartmentId,
    required final int caseId,
    required this.canEdit,
  }) {
    _caseId = caseId;
    _legalDepartmentId = legalDepartmentId;
  }

  late final PermissionService _perService;
  late final SubtaskDatasource _datasource;
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<SubtaskReadDto> subtasks = <SubtaskReadDto>[].obs;

  bool get haveAdminAccess => canEdit && _perService.haveLegalAdminAccess;

  @override
  void onInit() {
    _perService = Get.find();
    _datasource = Get.find();
    _getTasks();
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  void addOrUpdateSubtask(final SubtaskReadDto subtask) {
    final index = subtasks.indexWhere((final i) => i.id == subtask.id);
    if (index != -1) {
      subtasks[index] = subtask;
    } else {
      subtasks.insert(0, subtask);
    }
    _reloadHistory();
  }

  void deleteSubtask(final SubtaskReadDto subtask) {
    subtasks.removeWhere((final f) => f.id == subtask.id);
  }

  void _reloadHistory() {
    if (Get.isRegistered<LegalCaseReportsController>()) {
      Get.find<LegalCaseReportsController>().onInit();
    }
  }

  void onRefresh() {
    _getTasks();
  }

  void onTryAgain() {
    pageState.initial();
    _getTasks();
  }

  void createSubtask() async {
    bottomSheet(
      title: s.newTask,
      child: CreateUpdateSubtaskPage(
        dataSourceType: SubtaskDataSourceType.legal,
        mainSourceId: _legalDepartmentId.toString(),
        sourceId: _caseId,
        onResponse: addOrUpdateSubtask,
      ),
    );
  }

  void _getTasks() {
    _datasource.getSubtasks(
      dataSourceType: SubtaskDataSourceType.legal,
      sourceId: _caseId,
      onResponse: (final response) {
        if (subtasks.subject.isClosed) return;
        subtasks.assignAll(response.resultList ?? []);
        refreshController.refreshCompleted();
        pageState.loaded();
      },
      onError: (final errorResponse) {
        if (pageState.isInitial()) {
          pageState.error();
        }
        refreshController.refreshFailed();
      },
    );
  }
}
