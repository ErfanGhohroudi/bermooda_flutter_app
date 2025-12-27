import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:u/utilities.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/loading/loading.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';

class CreateUpdateTaskController extends GetxController {
  CreateUpdateTaskController({
    required this.task,
    required this.projectId,
    required this.selectedSection,
    final String? scrollToSubtaskId,
  }) : _scrollToSubtaskId = scrollToSubtaskId;

  final TaskDatasource _taskDatasource = Get.find<TaskDatasource>();
  TaskReadDto? task;
  late String projectId;
  String? _scrollToSubtaskId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AutoScrollController scrollController = AutoScrollController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  final PermissionService _perService = Get.find<PermissionService>();

  ProjectSectionReadDto? selectedSection;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxList<SubtaskReadDto> subtasks = <SubtaskReadDto>[].obs;

  bool get haveAdminAccess => _perService.haveProjectAdminAccess;

  bool get haveAccess => _perService.haveProjectAccess;

  bool get isCreate => task == null;

  bool get isUpdate => task != null;

  bool get isChanged =>
      isUpdate ? ((task?.title ?? '') != titleController.text || (task?.description ?? '') != descriptionController.text) : true;

  @override
  void onInit() {
    pageState.loading();
    if (isUpdate) {
      getTask();
    }
    super.onInit();
  }

  @override
  void onClose() {
    debugPrint("CreateUpdateTaskController closed!!!");
    titleController.dispose();
    descriptionController.dispose();
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

  void onSubmit({required final Function(TaskReadDto model) onResponse}) {
    validateForm(
      key: formKey,
      action: () {
        buttonState.loading();
        if (isCreate) {
          _create(onResponse: onResponse);
        } else {
          _update(onResponse: onResponse);
        }
      },
    );
  }

  void _create({required final Function(TaskReadDto model) onResponse}) {
    _taskDatasource.create(
      dto: TaskParams(
        title: titleController.text.trim(),
        description: descriptionController.text != '' ? descriptionController.text.trim() : null,
        subtasks: subtasks,
        projectId: projectId,
        sectionId: selectedSection?.id,
      ),
      onResponse: (final response) {
        onResponse(response.result!);
        buttonState.loaded();
      },
      onError: (final errorResponse) => buttonState.loaded(),
      withRetry: true,
    );
  }

  void _update({required final Function(TaskReadDto model) onResponse}) {
    _taskDatasource.update(
      taskId: task!.id,
      dto: TaskParams(
        title: titleController.text.trim(),
        description: descriptionController.text != '' ? descriptionController.text.trim() : null,
        projectId: projectId,
        sectionId: selectedSection?.id,
      ),
      onResponse: (final response) {
        onResponse(response.result!);
        buttonState.loaded();
      },
      onError: (final errorResponse) => buttonState.loaded(),
      withRetry: true,
    );
  }

  void getTask() {
    pageState.loading();
    _taskDatasource.getATask(
      taskId: task?.id,
      onResponse: (final response) {
        task = response.result;
        _setValues(task);
      },
      onError: (final errorResponse) {
        pageState.error();
      },
    );
  }

  void _setValues(final TaskReadDto? model) {
    selectedSection = model?.section;
    titleController.text = model?.title ?? '';
    descriptionController.text = model?.description ?? '';
    subtasks(model?.subtasks);
    pageState.loaded();

    if (_scrollToSubtaskId != null) {
      delay(
        500,
        () {
          scrollToSubtask(_scrollToSubtaskId!);
        },
      );
    }
  }

  void delete({required final VoidCallback action}) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        UNavigator.back();
        _delete(action: action);
      },
    );
  }

  void _delete({required final VoidCallback action}) {
    _taskDatasource.delete(
      taskId: task?.id,
      onResponse: action,
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }
}
