import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../core/functions/date_picker_functions.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../data/data.dart';
import '../../../reports/controllers/legal/legal_case_reports_controller.dart';

class LegalCaseFollowupListController extends GetxController {
  late final int _caseId;
  late final bool canEdit;

  LegalCaseFollowupListController({
    required final int caseId,
    required this.canEdit,
  }) : _caseId = caseId;

  late final PermissionService _perService;
  late final LegalFollowUpDatasource _datasource;
  final RefreshController refreshController = RefreshController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<FollowUpReadDto> followups = <FollowUpReadDto>[].obs;

  bool get haveAdminAccess => canEdit && _perService.haveLegalAdminAccess;

  @override
  void onInit() {
    _perService = Get.find();
    _datasource = Get.find();
    _getFollowups();
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  void addOrUpdateFollowUp(final FollowUpReadDto followUp) {
    final index = followups.indexWhere((final i) => i.slug == followUp.slug);
    if (index != -1) {
      followups[index] = followUp;
    } else {
      followups.add(followUp);
    }
    sortFollowUpList();
    _reloadHistory();
  }

  void deleteFollowUp(final FollowUpReadDto followUp) {
    followups.removeWhere((final f) => f.slug == followUp.slug);
  }

  void sortFollowUpList() {
    final updatedList = List<FollowUpReadDto>.from(followups);

    updatedList.sort((final a, final b) {
      final aDate = a.date?.formatCompactDate().numericOnly().toInt();
      final bDate = b.date?.formatCompactDate().numericOnly().toInt();
      if (bDate == null) return -1;
      if (aDate == null) return 1;
      return aDate.compareTo(bDate);
    });

    followups(updatedList);
  }

  void _reloadHistory() {
    if (Get.isRegistered<LegalCaseReportsController>()) {
      Get.find<LegalCaseReportsController>().onInit();
    }
  }

  void onRefresh() {
    _getFollowups();
  }

  void onTryAgain() {
    pageState.initial();
    _getFollowups();
  }

  void createFollowUp() async {
    final date = await DateAndTimeFunctions.showCustomPersianDatePicker(startDate: Jalali.now());
    if (date != null) {
      _datasource.create(
        sourceId: _caseId,
        date: date.formatCompactDate(),
        onResponse: (final response) {
          if (response.result == null) return;
          addOrUpdateFollowUp(response.result!);
        },
        onError: (final errorResponse) {},
      );
    }
  }

  void _getFollowups() {
    _datasource.getFollowups(
      caseId: _caseId,
      onResponse: (final response) {
        if (followups.subject.isClosed) return;
        followups.assignAll(response.resultList ?? []);
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
