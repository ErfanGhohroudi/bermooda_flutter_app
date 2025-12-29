import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../data/data.dart';
import '../../../core/loading/loading.dart';
import '../project/task/create_update/create_update_subtask/create_update_subtask_page.dart';
import '../reports/controllers/legal/legal_case_reports_controller.dart';
import '../reports/controllers/project/project_task_reports_controller.dart';

class SubtaskListController extends GetxController {
  late final String _mainSourceId;
  late final int _sourceId;
  late final SubtaskDataSourceType _dataSourceType;
  late final bool canEdit;
  String? _scrollToSubtaskId;

  SubtaskListController({
    required final String mainSourceId,
    required final int sourceId,
    required final SubtaskDataSourceType dataSourceType,
    final String? scrollToSubtaskId,
    required this.canEdit,
  }) {
    _mainSourceId = mainSourceId;
    _sourceId = sourceId;
    _dataSourceType = dataSourceType;
    _scrollToSubtaskId = scrollToSubtaskId;
  }

  late final PermissionService _perService;
  late final SubtaskDatasource _datasource;
  final RefreshController refreshController = RefreshController();
  final AutoScrollController scrollController = AutoScrollController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<SubtaskReadDto> subtasks = <SubtaskReadDto>[].obs;

  bool get haveAdminAccess => canEdit && switch (_dataSourceType) {
    SubtaskDataSourceType.project => _perService.haveProjectAdminAccess,
    SubtaskDataSourceType.legal => _perService.haveLegalAdminAccess,
  };

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
    scrollController.dispose();
    super.onClose();
  }

  /// scroll to subtask
  Future<void> scrollToSubtask(final String subtaskId) async {
    AppLoading.showLoading();
    final int index = subtasks.indexWhere((final e) => e.id == subtaskId);

    if (index != -1) {
      AppLoading.dismissLoading();
      await scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
      scrollController.highlight(index);
    } else {
      AppLoading.dismissLoading();
    }
    _scrollToSubtaskId = null;
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
    if (Get.isRegistered<ProjectTaskReportsController>()) {
      Get.find<ProjectTaskReportsController>().onInit();
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
      title: switch (_dataSourceType) {
        SubtaskDataSourceType.project => s.newSubtask,
        SubtaskDataSourceType.legal => s.newTask,
      },
      child: CreateUpdateSubtaskPage(
        dataSourceType: _dataSourceType,
        mainSourceId: _mainSourceId,
        sourceId: _sourceId,
        onResponse: addOrUpdateSubtask,
      ),
    );
  }

  void _getTasks() {
    _datasource.getSubtasks(
      dataSourceType: _dataSourceType,
      sourceId: _sourceId,
      onResponse: (final response) {
        if (subtasks.subject.isClosed) return;
        subtasks.assignAll(response.resultList ?? []);
        refreshController.refreshCompleted();
        pageState.loaded();

        if (_scrollToSubtaskId != null) {
          delay(
            500,
            () {
              scrollToSubtask(_scrollToSubtaskId!);
            },
          );
        }
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
