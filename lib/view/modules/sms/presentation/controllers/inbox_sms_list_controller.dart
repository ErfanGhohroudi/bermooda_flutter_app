import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:u/utilities.dart';

import '../../../../../data/data.dart';
import '../../../../../core/loading/loading.dart';
import '../../../../../core/navigator/navigator.dart';
import '../../../../../core/utils/extensions/url_extensions.dart';
import '../../data/repositories/sms_panel_repository_imp.dart';
import '../../domain/entity/received_sms_entity.dart';
import '../../domain/entity/sms_panel_number.dart';
import '../../domain/usecases/sms_usecases/get_numbers_by_department.dart';
import '../../domain/usecases/sms_usecases/get_inbox_sms_list.dart';

class InboxSmsListController extends GetxController {
  InboxSmsListController({
    required this.departmentId,
  });

  final int departmentId;

  final SmsPanelRepositoryImpl _repository = SmsPanelRepositoryImpl();

  late final GetInboxSmsListUseCase _getInboxSmsListUseCase = GetInboxSmsListUseCase(_repository);
  late final GetSmsNumbersByDepartmentUseCase _getNumbersByDepartmentUseCase = GetSmsNumbersByDepartmentUseCase(_repository);

  final TextEditingController searchCtrl = TextEditingController();
  final RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();

  final Rx<bool> showScrollToTop = false.obs;
  final Rx<PageState> pageState = PageState.initial.obs;

  bool isEndOfList = false;
  int pageNumber = 1;

  final RxList<ReceivedSmsEntity> smsList = <ReceivedSmsEntity>[].obs;
  final RxList<SmsPanelNumber> availableNumbers = <SmsPanelNumber>[].obs;

  // Filter Variables
  final Rxn<SmsPanelNumber> selectedPhone = Rxn<SmsPanelNumber>();
  final Rxn<Jalali> startDate = Rxn<Jalali>();
  final Rxn<Jalali> endDate = Rxn<Jalali>();

  bool get isFilterActive => selectedPhone.value != null || startDate.value != null || endDate.value != null;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    _getPhoneNumbers();
    _getList();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    searchCtrl.dispose();
    refreshController.dispose();
    pageState.close();
    smsList.close();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.offset > 350 && !showScrollToTop.value) {
      showScrollToTop(true);
    } else if (scrollController.offset <= 350 && showScrollToTop.value) {
      showScrollToTop(false);
    }
  }

  void onApplyFilter() {
    AppNavigator.back();
    onSearch();
  }

  void onClearFilter() {
    selectedPhone.value = null;
    startDate.value = null;
    endDate.value = null;
    AppNavigator.back();
    onSearch();
  }

  void onTryAgain() {
    pageState.initial();
    onRefresh();
  }

  void onSearch() {
    pageState.initial();
    onRefresh();
  }

  void onRefresh() {
    pageNumber = 1;
    _getList();
  }

  void loadMore() {
    pageNumber++;
    _getList();
  }

  void _getPhoneNumbers() async {
    try {
      final response = await _getNumbersByDepartmentUseCase(
        departmentId: departmentId,
        pageNumber: 1,
      );
      if (response.status == true && response.resultList != null) {
        availableNumbers.assignAll(response.resultList!);
      }
    } catch (e) {
      // Handle error or ignore
    }
  }

  Future<void> onExportExcel() async {
    try {
      AppLoading.showLoading();
      final response = await _getInboxSmsListUseCase(
        departmentId: departmentId,
        pageNumber: 1,
        search: searchCtrl.text.trim().isNotEmpty ? searchCtrl.text.trim() : null,
        phoneId: selectedPhone.value?.id,
        startDate: startDate.value,
        endDate: endDate.value,
        isExport: true,
      );
      AppLoading.dismissLoading();

      if (response.status == true && response.exportedFile != null) {
        final file = MainFileReadDto.fromMap(response.exportedFile!);
        final url = file.url;
        await url.launchMyUrl();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _getList() async {
    try {
      final response = await _getInboxSmsListUseCase(
        departmentId: departmentId,
        pageNumber: pageNumber,
        search: searchCtrl.text.trim().isNotEmpty ? searchCtrl.text.trim() : null,
        phoneId: selectedPhone.value?.id,
        startDate: startDate.value,
        endDate: endDate.value,
      );

      if (smsList.subject.isClosed) return;
      if (pageNumber == 1) {
        smsList.assignAll(response.resultList ?? []);
        refreshController.refreshCompleted();
      } else {
        smsList.addAll(response.resultList ?? []);
      }

      if (response.extra?.next == null || (response.resultList?.isEmpty ?? true)) {
        refreshController.loadNoData();
        isEndOfList = true;
      } else {
        refreshController.loadComplete();
        isEndOfList = false;
      }

      pageState.loaded();
    } catch (e) {
      if (pageState.isInitial()) {
        pageState.error();
      }
      if (pageNumber == 1) {
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }
    }
  }

  void applyFilters() {
    Get.back(); // Close filter sheet
    onRefresh();
  }

  void clearFilters() {
    selectedPhone.value = null;
    startDate.value = null;
    endDate.value = null;
    Get.back(); // Close filter sheet
    onRefresh();
  }
}
