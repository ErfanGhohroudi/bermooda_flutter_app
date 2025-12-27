import 'package:u/utilities.dart';

import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../data/data.dart';
import '../../../../../core/core.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../view/modules/reports/controllers/crm/crm_customer_reports_controller.dart';
import '../../../view/modules/reports/controllers/legal/legal_case_reports_controller.dart';
import '../../../view/modules/project/task/create_update/create_update_subtask/create_update_subtask_page.dart';
import '../../../view/modules/project/task/create_update/create_update_task_controller.dart';

mixin SubtaskCardController {
  final core = Get.find<Core>();
  final _perService = Get.find<PermissionService>();
  final SubtaskDatasource _datasource = Get.find<SubtaskDatasource>();
  Rx<SubtaskReadDto> subtask = const SubtaskReadDto(id: '').obs;

  bool get isMySubtask => subtask.value.responsibleForDoing?.id == core.userReadDto.value.id && haveAccess;

  bool get haveAdminAccess => switch(subtask.value.dataSourceType) {
    null => false,
    SubtaskDataSourceType.project => _perService.haveProjectAdminAccess,
    SubtaskDataSourceType.legal => _perService.haveLegalAdminAccess,
  };

  bool get haveAccess => switch(subtask.value.dataSourceType) {
    null => false,
    SubtaskDataSourceType.project => _perService.haveProjectAccess,
    SubtaskDataSourceType.legal => _perService.haveLegalAccess,
  };

  void onEditTaped({required final Function(SubtaskReadDto) onResponse}) {
    if (subtask.value.dataSourceType == null) return;
    bottomSheet(
      title: s.editSubtask,
      child: CreateUpdateSubtaskPage(
        dataSourceType: subtask.value.dataSourceType!,
        mainSourceId: subtask.value.mainSourceId ?? '',
        sourceId: subtask.value.taskId ?? subtask.value.legalCaseId,
        model: subtask.value,
        onResponse: (final model) {
          subtask(model);
          delay(200, () => onResponse(model));
        },
      ),
    );
  }

  void deleteSubtask({required final VoidCallback action}) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureToDeleteMessage,
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        if (subtask.value.dataSourceType == null) return;
        UNavigator.back();
        _datasource.delete(
          dataSourceType: subtask.value.dataSourceType!,
          id: subtask.value.id,
          onResponse: () => action(),
          onError: (final errorResponse) {},
          withRetry: true,
        );
      },
    );
  }

  void changedTimerStatus({
    required final TimerStatusCommand command,
    required final Function(SubtaskReadDto model) onChangedTimer,
  }) {
    if (subtask.value.responsibleForDoing?.id != core.userReadDto.value.id) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.notAuthorizedToChangeStatus);
      return;
    }
    if (subtask.value.dataSourceType == null) return;
    _datasource.changeTimerStatus(
      dataSourceType: subtask.value.dataSourceType!,
      id: subtask.value.timer?.id,
      command: command,
      onResponse: (final response) {
        subtask(response.result);
        onChangedTimer(subtask.value);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void changeSubtaskStatus({
    required final Function(SubtaskReadDto model) onResponse,
  }) {
    if (subtask.value.responsibleForDoing?.id != core.userReadDto.value.id) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.notAuthorizedToChangeStatus);
      return;
    }

    appShowYesCancelDialog(
      description: subtask.value.isCompleted ? s.changeStatus : s.changeSubtaskStatusToDone,
      onYesButtonTap: () {
        UNavigator.back();
        _changeSubStatus(onResponse);
      },
    );
  }

  void _changeSubStatus(final Function(SubtaskReadDto model) onResponse) {
    if (subtask.value.dataSourceType == null) return;
    _datasource.changeChecklistStatus(
      dataSourceType: subtask.value.dataSourceType!,
      id: subtask.value.id,
      status: !subtask.value.isCompleted,
      onResponse: (final response) {
        if (subtask.subject.isClosed && response.result == null) return;
        subtask(response.result!);
        onResponse(response.result!);
        _reloadHistoryPage();
        _reloadTaskPage();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void changeProgress(final int value, {required final Function(SubtaskReadDto model) onResponse}) {
    if (subtask.value.responsibleForDoing?.id != core.userReadDto.value.id) {
      AppNavigator.snackbarRed(title: s.error, subtitle: s.notAuthorizedToChangeStatus);
      return;
    }
    appShowYesCancelDialog(
      description: s.changeSubtaskProgressTo.replaceAll("#", "$value%"),
      onYesButtonTap: () {
        UNavigator.back();
        _changeProgress(value, onResponse);
      },
    );
  }

  void _changeProgress(final int value, final Function(SubtaskReadDto model) onResponse) {
    if (subtask.value.dataSourceType == null) return;
    final dataSourceType = subtask.value.dataSourceType!;
    _datasource.changeProgress(
      dataSourceType: dataSourceType,
      slug: switch (dataSourceType) {
        SubtaskDataSourceType.project => subtask.value.slug,
        SubtaskDataSourceType.legal => subtask.value.id,
      },
      value: value,
      onResponse: (final response) {
        if (subtask.subject.isClosed && response.result == null) return;
        subtask(response.result!);
        onResponse(response.result!);
        _reloadHistoryPage();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void _reloadHistoryPage() {
    if (Get.isRegistered<CrmCustomerReportsController>()) {
      Get.find<CrmCustomerReportsController>().onInit();
    }
    if (Get.isRegistered<LegalCaseReportsController>()) {
      Get.find<LegalCaseReportsController>().onInit();
    }
  }

  void _reloadTaskPage() {
    if (Get.isRegistered<CreateUpdateTaskController>()) {
      Get.find<CreateUpdateTaskController>().onInit();
    }
  }
}
