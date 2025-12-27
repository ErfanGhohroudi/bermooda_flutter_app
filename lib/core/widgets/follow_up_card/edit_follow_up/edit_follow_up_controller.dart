import 'package:u/utilities.dart';

import '../../../../../../core/widgets/image_files.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../data/data.dart';
import '../../../../view/modules/reports/controllers/crm/crm_customer_reports_controller.dart';
import '../../../../view/modules/reports/controllers/legal/legal_case_reports_controller.dart';

mixin EditFollowUpController {
  late FollowUpReadDto followUp;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Rx<PageState> membersState = PageState.loading.obs;
  final Rx<PageState> buttonState = PageState.loaded.obs;
  List<UserReadDto> members = <UserReadDto>[];
  bool isUploadingFile = false;

  IFollowUpDatasource? get _datasource {
    switch (followUp.dataSourceType) {
      case FollowUpDataSource.crm:
        return Get.find<CustomerFollowUpDatasource>();
      case FollowUpDataSource.legal:
        return Get.find<LegalFollowUpDatasource>();
      default:
        return null;
    }
  }

  void initialController({required final FollowUpReadDto followUp}) {
    this.followUp = followUp.copyWith();
    getMembers();
  }

  void disposeItems() {
    buttonState.close();
    membersState.close();
  }

  void onSubmit({required final Function(FollowUpReadDto model) action}) {
    WImageFiles.checkFileUploading(
      isUploadingFile: isUploadingFile,
      action: () {
        validateForm(
          key: formKey,
          action: () {
            final selectedTime = followUp.time?.split(':');
            final selectedDate = followUp.date == null
                ? null
                : Jalali(
                    followUp.date?.year ?? 0,
                    followUp.date?.month ?? 0,
                    followUp.date?.day ?? 0,
                    selectedTime?.firstOrNull?.toInt() ?? 23,
                    selectedTime?.lastOrNull?.toInt() ?? 59,
                    59,
                  );
            final now = Jalali.now().copyWith(second: 0, millisecond: 0);

            if (selectedDate?.isBefore(now) ?? false) {
              return AppNavigator.snackbarRed(title: s.warning, subtitle: s.timeMustBeSetInFuture);
            }

            _update(action);
          },
        );
      },
    );
  }

  void _reloadHistory() {
    if (Get.isRegistered<CrmCustomerReportsController>()) {
      Get.find<CrmCustomerReportsController>().onInit();
    }
    if (Get.isRegistered<LegalCaseReportsController>()) {
      Get.find<LegalCaseReportsController>().onInit();
    }
  }

  void _update(final Function(FollowUpReadDto model) action) {
    final datasource = _datasource;
    if (datasource == null) return;
    buttonState.loading();
    datasource.update(
      slug: followUp.slug,
      date: followUp.date?.formatCompactDate(),
      time: followUp.time,
      trackerId: followUp.assignedUser?.id,
      files: followUp.files,
      onResponse: (final response) {
        buttonState.loaded();
        action(response.result!);
        _reloadHistory();
      },
      onError: (final errorResponse) {},
      withRetry: true,
    );
  }

  void getMembers() {
    final MemberDatasource datasource = Get.find<MemberDatasource>();
    membersState.loading();
    datasource.getSourceMembers(
      sourceType: MemberSourceType.legalDepartment,
      sourceId: followUp.mainSourceId,
      onResponse: (final response) {
        members.assignAll(response.resultList!);
        membersState.loaded();
      },
      onError: (final errorResponse) {},
    );
  }
}
