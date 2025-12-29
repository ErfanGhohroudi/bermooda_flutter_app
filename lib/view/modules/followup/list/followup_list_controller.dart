import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:u/utilities.dart';

import '../../../../../core/functions/date_picker_functions.dart';
import '../../../../../core/services/permission_service.dart';
import '../../../../../data/data.dart';
import '../../../../core/core.dart';
import '../../../../core/loading/loading.dart';
import '../../crm/my_followups/my_followups_controller.dart';
import '../../reports/controllers/crm/crm_customer_reports_controller.dart';
import '../../reports/controllers/legal/legal_case_reports_controller.dart';

class FollowupListController extends GetxController {
  late final IFollowUpDatasource _datasource;
  late final int _sourceId;
  late final bool canEdit;
  String? _scrollToFollowupSlug;

  FollowupListController({
    required final IFollowUpDatasource datasource,
    required final int sourceId,
    final String? scrollToFollowupSlug,
    required this.canEdit,
  }) {
    _sourceId = sourceId;
    _datasource = datasource;
    _scrollToFollowupSlug = scrollToFollowupSlug;
  }

  late final Core _core;
  late final PermissionService _perService;
  final RefreshController refreshController = RefreshController();
  final AutoScrollController scrollController = AutoScrollController();
  final Rx<PageState> pageState = PageState.initial.obs;
  final RxList<FollowUpReadDto> followups = <FollowUpReadDto>[].obs;

  bool get haveAdminAccess => canEdit && _perService.haveLegalAdminAccess;

  @override
  void onInit() {
    _core = Get.find();
    _perService = Get.find();
    _getFollowups();
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  /// scroll to followup
  Future<void> scrollToItem(final String followupSlug) async {
    AppLoading.showLoading();
    final int index = followups.indexWhere((final e) => e.slug == followupSlug);

    if (index != -1) {
      AppLoading.dismissLoading();
      await scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
      scrollController.highlight(index);
    } else {
      AppLoading.dismissLoading();
    }
    _scrollToFollowupSlug = null;
  }

  void addOrUpdateFollowUp(final FollowUpReadDto followUp) {
    final index = followups.indexWhere((final i) => i.slug == followUp.slug);
    if (index != -1) {
      followups[index] = followUp;
    } else {
      followups.add(followUp);
    }
    sortFollowUpList();
    _reloadReports();
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

  void _reloadReports() {
    if (Get.isRegistered<LegalCaseReportsController>()) {
      Get.find<LegalCaseReportsController>().onInit();
    }
    if (Get.isRegistered<CrmCustomerReportsController>()) {
      Get.find<CrmCustomerReportsController>().onInit();
    }
  }

  void _insertAtMyFollowUps(final FollowUpReadDto model) {
    if (model.assignedUser?.id != _core.userReadDto.value.id) return;
    if (Get.isRegistered<MyFollowupsController>()) {
      Get.find<MyFollowupsController>().insertItem(model);
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
        sourceId: _sourceId,
        date: date.formatCompactDate(),
        onResponse: (final response) {
          if (response.result == null) return;
          addOrUpdateFollowUp(response.result!);
          _insertAtMyFollowUps(response.result!);
        },
        onError: (final errorResponse) {},
      );
    }
  }

  void _getFollowups() {
    _datasource.getFollowups(
      sourceId: _sourceId,
      onResponse: (final response) {
        if (followups.subject.isClosed) return;
        followups.assignAll(response.resultList ?? []);
        refreshController.refreshCompleted();
        pageState.loaded();
        if (_scrollToFollowupSlug != null) {
          delay(
            500,
            () {
              scrollToItem(_scrollToFollowupSlug!);
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
