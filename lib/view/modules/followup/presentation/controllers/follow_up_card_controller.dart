import 'package:u/utilities.dart';

import '../../../reports/controllers/crm/crm_customer_reports_controller.dart';
import '../../../reports/controllers/legal/legal_case_reports_controller.dart';
import '../../../legal/my_cases/my_cases_controller.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../core/core.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../core/theme.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import '../../../crm/my_followups/my_followups_controller.dart';
import '../../../sms/presentation/sheets/send_sms_sheet.dart';
import '../pages/follow_up_details_page.dart';

class FollowUpCardController {
  FollowUpCardController({
    required final FollowUpReadDto followUp,
  }) {
    this.followUp = followUp.obs;
    _perService = Get.find<PermissionService>();
    _core = Get.find<Core>();
  }

  late final PermissionService _perService;
  late final Core _core;

  late final Rx<FollowUpReadDto> followUp;

  bool get isMyFollowUp => followUp.value.assignedUser?.id == _core.userReadDto.value.id;

  bool get haveAdminAccess => switch (followUp.value.dataSourceType) {
    null => false,
    FollowUpDataSource.crm => _perService.haveCRMAdminAccess,
    FollowUpDataSource.legal => _perService.haveLegalAdminAccess,
  };

  bool get haveAccess => switch (followUp.value.dataSourceType) {
    null => false,
    FollowUpDataSource.crm => _perService.haveCRMAccess,
    FollowUpDataSource.legal => _perService.haveLegalAccess,
  };

  IFollowUpDatasource? get _datasource {
    switch (followUp.value.dataSourceType) {
      case FollowUpDataSource.crm:
        return Get.find<CustomerFollowUpDatasource>();
      case FollowUpDataSource.legal:
        return Get.find<LegalFollowUpDatasource>();
      default:
        return null;
    }
  }

  void disposeItems() {
    followUp.close();
  }

  void handleMyFollowUpsChanges(
    final FollowUpReadDto oldModel,
    final FollowUpReadDto newModel,
  ) {
    if (oldModel.assignedUser?.id == _core.userReadDto.value.id && newModel.assignedUser?.id != _core.userReadDto.value.id) {
      return _removeFromMyFollowUps(oldModel);
    }
    if (oldModel.assignedUser?.id != _core.userReadDto.value.id && newModel.assignedUser?.id == _core.userReadDto.value.id) {
      return _insertAtMyFollowUps(newModel);
    }
    if (newModel.assignedUser?.id == _core.userReadDto.value.id) {
      return _updateAtMyFollowUps(newModel);
    }
  }

  void _insertAtMyFollowUps(final FollowUpReadDto model) {
    if (model.assignedUser?.id != _core.userReadDto.value.id) return;
    if (Get.isRegistered<MyFollowupsController>()) {
      Get.find<MyFollowupsController>().insertItem(model);
    }
    if (Get.isRegistered<MyCasesController>()) {
      Get.find<MyCasesController>().onRefresh();
    }
  }

  void _updateAtMyFollowUps(final FollowUpReadDto model) {
    if (Get.isRegistered<MyFollowupsController>()) {
      Get.find<MyFollowupsController>().updateItem(model);
    }
  }

  void _removeFromMyFollowUps(final FollowUpReadDto model) {
    if (Get.isRegistered<MyFollowupsController>()) {
      Get.find<MyFollowupsController>().removeItem(model);
    }
  }

  void onTapFollowUpCheckBox({
    required final FollowUpReadDto followUp,
    required final Function(FollowUpReadDto model) onResponse,
  }) {
    if (!followUp.isFollowed && followUp.assignedUser?.id == _core.userReadDto.value.id) {
      appShowYesCancelDialog(
        description: s.followUpStatusPopupDescription,
        cancelButtonTitle: s.no,
        cancelBackgroundColor: AppColors.red,
        yesBackgroundColor: AppColors.green,
        onCancelButtonTap: () {
          AppNavigator.back();
          _changedStatus(isSuccessFull: false, onResponse: onResponse);
        },
        onYesButtonTap: () {
          AppNavigator.back();
          _changedStatus(isSuccessFull: true, onResponse: onResponse);
        },
      );
    } else {
      AppSnackBar.snackbarRed(title: s.warning, subtitle: s.notAuthorizedToChangeStatus);
    }
  }

  void delete({required final VoidCallback onResponse}) {
    appShowYesCancelDialog(
      title: s.delete,
      description: s.areYouSureYouWantToDeleteItem(s.followUp.toLowerCase()),
      yesButtonTitle: s.delete,
      yesBackgroundColor: AppColors.red,
      onYesButtonTap: () {
        AppNavigator.back();
        _delete(onResponse: onResponse);
      },
    );
  }

  void _delete({required final VoidCallback onResponse}) {
    _datasource?.delete(
      slug: followUp.value.slug,
      onResponse: () {
        if (followUp.value.assignedUser?.id == _core.userReadDto.value.id) {
          _removeFromMyFollowUps(followUp.value.copyWith());
        }
        onResponse();
        AppNavigator.back();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void changedTimerStatus({
    required final TimerStatusCommand command,
    required final Function(FollowUpReadDto model) onChangedTimer,
  }) {
    _datasource?.changeTimerStatus(
      slug: followUp.value.timer?.slug ?? followUp.value.timer?.id?.toString(),
      command: command,
      onResponse: (final response) {
        if (response.result == null) return;
        final oldModel = followUp.value.copyWith();
        followUp(response.result);
        handleMyFollowUpsChanges(oldModel, followUp.value.copyWith());
        onChangedTimer(followUp.value);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void _reloadReports() {
    if (Get.isRegistered<CrmCustomerReportsController>()) {
      Get.find<CrmCustomerReportsController>().onInit();
    }
    if (Get.isRegistered<LegalCaseReportsController>()) {
      Get.find<LegalCaseReportsController>().onInit();
    }
  }

  void _changedStatus({
    required final bool isSuccessFull,
    required final Function(FollowUpReadDto model) onResponse,
  }) {
    _datasource?.changeStatus(
      slug: followUp.value.slug,
      isSuccessFull: isSuccessFull,
      onResponse: (final response) {
        if (response.result == null) return;
        final oldModel = followUp.value.copyWith();
        followUp(response.result);
        _reloadReports();
        handleMyFollowUpsChanges(oldModel, followUp.value.copyWith());
        onResponse(followUp.value);
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void navigateToDetailsPage({
    required final bool showSourceData,
    required final bool canManage,
    required final Function(FollowUpReadDto model) onChanged,
    required final Function() onDelete,
  }) {
    AppNavigator.push(
      FollowUpDetailsPage(
        ctrl: this,
        followUp: followUp.value,
        showSourceData: showSourceData,
        canManage: canManage,
        onChanged: (final model) {
          followUp(model);
          onChanged(model);
        },
        onDelete: onDelete,
      ),
    );
  }

  void showSendSmsBottomSheet() async {
    if (followUp.value.dataSourceType == null) return;
    String? recipientPhoneNumber;
    if (followUp.value.dataSourceType!.isCrm) {
      if (followUp.value.customerData?.phoneNumber != null) {
        recipientPhoneNumber = followUp.value.customerData?.phoneNumber;
        return;
      } else {
        AppSnackBar.snackbarRed(title: s.error, subtitle: s.isRequired(s.customerPhoneNumber));
      }
    } else if (followUp.value.dataSourceType!.isLegal) {
      // if (followUp.value.caseData?.phoneNumber != null) {
      //   recipientPhoneNumber = followUp.value.caseData?.phoneNumber;
      //   return;
      // } else {
      //   AppSnackBar.snackbarRed(title: s.error, subtitle: s.isRequired(''));
      // }
    }

    return await bottomSheet(
      title: s.sendSMS,
      childBuilder: (final context) => SendSmsSheet(
        recipientPhoneNumber: recipientPhoneNumber,
        showScheduledAt: false,
      ),
    );
  }
}
